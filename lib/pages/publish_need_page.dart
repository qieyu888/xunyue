import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/need_post.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/local_image.dart';

class PublishNeedPage extends StatefulWidget {
  const PublishNeedPage({super.key});

  @override
  State<PublishNeedPage> createState() => _PublishNeedPageState();
}

class _PublishNeedPageState extends State<PublishNeedPage> {
  final TextEditingController _content = TextEditingController();
  final TextEditingController _location = TextEditingController(text: '浙江 杭州');
  final TextEditingController _timeStart = TextEditingController();
  final TextEditingController _timeEnd = TextEditingController();

  String _type = '找模特';
  String _pay = '互勉约拍';
  final List<String> _images = [];

  static const _types = ['找模特', '找摄影', '找妆造'];
  static const _pays = ['互勉约拍', '付费约拍', '收费约拍'];

  @override
  void dispose() {
    _content.dispose();
    _location.dispose();
    _timeStart.dispose();
    _timeEnd.dispose();
    super.dispose();
  }

  static const _maxImages = 3;

  Future<void> _addReferenceImage() async {
    final remaining = _maxImages - _images.length;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    try {
      final List<XFile> picked;
      if (remaining == 1) {
        final file = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 88,
        );
        picked = file == null ? const [] : [file];
      } else {
        picked = await picker.pickMultiImage(
          maxWidth: 1600,
          maxHeight: 1600,
          imageQuality: 88,
          limit: remaining,
        );
      }
      if (picked.isEmpty || !mounted) return;

      final docs = await getApplicationDocumentsDirectory();
      final saved = <String>[];
      for (final file in picked.take(remaining)) {
        final ext = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
        final destPath = p.join(
          docs.path,
          'need_ref_${DateTime.now().millisecondsSinceEpoch}_${saved.length}$ext',
        );
        await File(file.path).copy(destPath);
        saved.add(destPath);
      }
      if (!mounted || saved.isEmpty) return;
      setState(() => _images.addAll(saved));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('图片读取失败，请重试')),
      );
    }
  }

  void _publish() {
    final text = _content.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先填写需求描述')),
      );
      return;
    }

    final profile = AppScope.storeOf(context).profile;
    final tags = <String>[
      if (_location.text.trim().isNotEmpty) '地点: ${_location.text.trim()}',
      _pay,
      if (_timeStart.text.trim().isNotEmpty) '时间: ${_timeStart.text.trim()}',
    ];

    final need = NeedPost(
      id: DateTime.now().millisecondsSinceEpoch,
      author: profile.nickname,
      avatar: profile.avatar,
      type: _type,
      tags: tags,
      content: text,
      images: List<String>.from(_images),
      time: '刚刚发布',
      location: _location.text.trim(),
      payMode: _pay,
    );

    Navigator.pop(context, need);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 48,
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '发布需求',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GradientButton(
                    label: '发布',
                    onTap: _publish,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    fontSize: 13,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '需求类型',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: _types.map((type) {
                          final selected = _type == type;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: type == _types.last ? 0 : 8,
                              ),
                              child: GestureDetector(
                                onTap: () => setState(() => _type = type),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.roseLight
                                        : const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.roseBorder
                                          : Colors.transparent,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selected
                                          ? AppColors.rose
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _content,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '描述你的约拍需求，例如：周末想去外滩拍一组日系甜美风的胶片...',
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ..._images.map((path) {
                            return Stack(
                              children: [
                                LocalCover(
                                  path: path,
                                  width: 88,
                                  height: 88,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _images.remove(path)),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          if (_images.length < _maxImages)
                            GestureDetector(
                              onTap: _addReferenceImage,
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFD1D5DB),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined, color: AppColors.textMuted),
                                    SizedBox(height: 4),
                                    Text(
                                      '添加参考图',
                                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _Card(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '费用模式',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                spacing: 6,
                                children: _pays.map((pay) {
                                  final selected = _pay == pay;
                                  return GestureDetector(
                                    onTap: () => setState(() => _pay = pay),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: selected ? AppTheme.brandGradient : null,
                                        color: selected ? null : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        pay,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: selected
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                '约拍地点',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const Icon(Icons.place_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: _location,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: '输入地点...',
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '期望时间',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _TimeBox(
                                    controller: _timeStart,
                                    hint: '开始时间',
                                    onTap: () => _pickDateTime(_timeStart),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '至',
                                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ),
                                Expanded(
                                  child: _TimeBox(
                                    controller: _timeEnd,
                                    hint: '结束时间',
                                    onTap: () => _pickDateTime(_timeEnd),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    controller.text =
        '${date.month}/${date.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    setState(() {});
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.controller,
    required this.hint,
    required this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Text(
          controller.text.isEmpty ? hint : controller.text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: controller.text.isEmpty ? AppColors.textMuted : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
