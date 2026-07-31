import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/local_image.dart';

/// 帮助与反馈 / 我要投诉
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({
    super.key,
    required this.title,
    this.isComplaint = false,
  });

  final String title;
  final bool isComplaint;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _content = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final List<String> _images = [];
  String _type = '功能建议';

  late final List<String> _types;

  static const _maxImages = 3;

  static const _faqs = <(String, String)>[
    (
      '如何发布约拍需求？',
      '进入「寻约」页，点击右上角发布按钮，填写需求类型、描述、费用模式、地点与期望时间，可添加 1–3 张参考图后提交。',
    ),
    (
      '点赞和收藏保存在哪里？',
      '点赞、收藏、关注等互动记录保存在本机。收藏内容可在「我的 → 收藏」中查看；退出账号会清除互动记录。',
    ),
    (
      '如何修改个人资料与头像？',
      '进入「我的」点击「编辑资料」，可修改昵称、角色、城市、标签、简介，并支持从相册更换头像。',
    ),
    (
      '退出和注销有什么区别？',
      '退出账号会清除本地点赞、收藏与关注，个人资料仍保留。注销账号会清空本机个人资料、已发布需求及全部互动记录，且不可恢复。',
    ),
    (
      '相册权限打不开怎么办？',
      '请在系统设置中为本应用开启相册/照片权限后重试。关闭权限不影响浏览，但无法更换头像或上传参考图。',
    ),
    (
      '如何联系客服？',
      '可通过本页提交反馈，或发送邮件至 1038431358@qq.com。投诉请使用「我要投诉」通道并尽量提供截图说明。',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _types = widget.isComplaint
        ? const ['虚假信息', '骚扰辱骂', '侵权抄袭', '安全隐患', '其他']
        : const ['功能建议', '使用问题', '内容反馈', '其他'];
    _type = _types.first;
  }

  @override
  void dispose() {
    _content.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
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
          'complaint_${DateTime.now().millisecondsSinceEpoch}_${saved.length}$ext',
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

  void _submit() {
    if (_content.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isComplaint ? '请填写投诉内容' : '请填写反馈内容')),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(widget.isComplaint ? '投诉已提交，我们会尽快处理' : '感谢反馈，我们已收到'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          if (!widget.isComplaint) ...[
            _FaqSection(faqs: _faqs),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isComplaint ? '投诉类型' : '反馈类型',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _types.map((type) {
                    final selected = _type == type;
                    return GestureDetector(
                      onTap: () => setState(() => _type = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.roseLight : AppColors.bg,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: selected
                                ? AppColors.roseBorder
                                : Colors.transparent,
                          ),
                        ),
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.isComplaint ? '投诉详情' : '问题描述',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _content,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: widget.isComplaint
                        ? '请尽量描述时间、对象与具体情况，便于我们核实处理'
                        : '请描述你遇到的问题或建议，越具体越好',
                    filled: true,
                    fillColor: AppColors.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (widget.isComplaint) ...[
                  const SizedBox(height: 18),
                  const Text(
                    '上传凭证（最多3张）',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                                  child: const Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (_images.length < _maxImages)
                        GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD1D5DB)),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.textMuted),
                                SizedBox(height: 4),
                                Text(
                                  '添加图片',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                const Text(
                  '联系方式（选填）',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contact,
                  decoration: InputDecoration(
                    hintText: '邮箱 / 手机号，方便我们回访',
                    filled: true,
                    fillColor: AppColors.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GradientButton(
              label: '提交',
              onTap: _submit,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              fontSize: 15,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({required this.faqs});

  final List<(String, String)> faqs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              '常见问题解答',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...List.generate(faqs.length, (index) {
            final item = faqs[index];
            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                title: Text(
                  item.$1,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.55,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
