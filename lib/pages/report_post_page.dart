import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/common_widgets.dart';
import '../widgets/local_image.dart';

/// 举报帖子/用户：文字说明 + 最多 3 张本地图片
class ReportPostPage extends StatefulWidget {
  const ReportPostPage({
    super.key,
    required this.author,
    required this.onHideContent,
    this.returnTabIndex = 0,
  });

  final String author;
  final Future<void> Function() onHideContent;

  /// 提交后回到的主壳 Tab：0 首页 / 2 动态
  final int returnTabIndex;

  @override
  State<ReportPostPage> createState() => _ReportPostPageState();
}

class _ReportPostPageState extends State<ReportPostPage> {
  final TextEditingController _content = TextEditingController();
  final List<String> _images = [];

  static const _maxImages = 3;

  @override
  void dispose() {
    _content.dispose();
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
        final ext =
            p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
        final destPath = p.join(
          docs.path,
          'report_${DateTime.now().millisecondsSinceEpoch}_${saved.length}$ext',
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

  Future<void> _submit() async {
    if (_content.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写举报说明')),
      );
      return;
    }

    final scope = AppScope.of(context);
    final store = scope.store;
    await widget.onHideContent();
    store.selectMainTab(widget.returnTabIndex);
    scope.refresh();

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      const SnackBar(content: Text('举报已提交，相关内容已屏蔽')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('举报'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '投诉用户：${widget.author}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '举报说明',
                  style: TextStyle(
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
                    hintText: '请说明举报原因，便于我们核实处理',
                    filled: true,
                    fillColor: AppColors.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
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
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.textMuted,
                              ),
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
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GradientButton(
              label: '确定举报',
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
