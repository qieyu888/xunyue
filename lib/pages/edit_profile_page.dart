import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../theme/app_theme.dart';
import '../widgets/app_scope.dart';
import '../widgets/local_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nickname;
  late final TextEditingController _city;
  late final TextEditingController _tags;
  late final TextEditingController _bio;
  late String _gender;
  late String _role;
  late String _birthday;
  late String _avatar;
  bool _loaded = false;

  static const _genders = ['女', '男', '保密'];
  static const _roles = ['独立模特', '摄影师', '化妆师', '爱好者'];

  @override
  void initState() {
    super.initState();
    _nickname = TextEditingController();
    _city = TextEditingController();
    _tags = TextEditingController();
    _bio = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final profile = AppScope.storeOf(context).profile;
    _nickname.text = profile.nickname;
    _city.text = profile.city;
    _tags.text = profile.tags;
    _bio.text = profile.bio;
    _gender = profile.gender;
    _role = profile.role;
    _birthday = profile.birthday;
    _avatar = profile.avatar;
  }

  @override
  void dispose() {
    _nickname.dispose();
    _city.dispose();
    _tags.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final scope = AppScope.of(context);
    final current = scope.store.profile;
    final next = current.copyWith(
      nickname: _nickname.text.trim().isEmpty ? current.nickname : _nickname.text.trim(),
      city: _city.text.trim(),
      tags: _tags.text.trim(),
      bio: _bio.text.trim(),
      gender: _gender,
      role: _role,
      birthday: _birthday,
      avatar: _avatar,
    );
    await scope.store.saveProfile(next);
    scope.refresh();
    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('资料已保存')),
      );
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 88,
    );
    if (file == null || !mounted) return;

    try {
      final docs = await getApplicationDocumentsDirectory();
      final ext = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
      final destPath = p.join(
        docs.path,
        'avatar_${DateTime.now().millisecondsSinceEpoch}$ext',
      );
      await File(file.path).copy(destPath);
      if (!mounted) return;
      setState(() => _avatar = destPath);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('头像读取失败，请重试')),
      );
    }
  }

  Future<void> _pickBirthday() async {
    final initial = DateTime.tryParse(_birthday) ?? DateTime(2000, 6, 12);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthday =
            '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = AppScope.storeOf(context).profile;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, size: 30),
                  ),
                  const Expanded(
                    child: Text(
                      '编辑资料',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _save,
                    child: const ShaderMask(
                      shaderCallback: _brandShader,
                      child: Text(
                        '保存',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Stack(
                          children: [
                            LocalAvatar(path: _avatar, size: 80, borderWidth: 2),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF111827),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '点击更换头像',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _Section(
                  children: [
                    _FieldRow(
                      label: '昵称',
                      child: TextField(
                        controller: _nickname,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    _FieldRow(
                      label: '约拍号',
                      child: Text(
                        profile.userId,
                        style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                      ),
                    ),
                    _FieldRow(
                      label: '性别',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          isDense: true,
                          items: _genders
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _gender = v);
                          },
                        ),
                      ),
                    ),
                    _FieldRow(
                      label: '生日',
                      child: GestureDetector(
                        onTap: _pickBirthday,
                        child: Text(
                          _birthday,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                    _FieldRow(
                      label: '所在城市',
                      showDivider: false,
                      child: TextField(
                        controller: _city,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '输入所在城市...',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _Section(
                  children: [
                    _FieldRow(
                      label: '身份',
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.roseLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.roseBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _role,
                            isDense: true,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.rose,
                              fontWeight: FontWeight.w600,
                            ),
                            items: _roles
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _role = v);
                            },
                          ),
                        ),
                      ),
                    ),
                    _FieldRow(
                      label: '个人标签',
                      child: TextField(
                        controller: _tags,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: '输入标签，用空格分隔',
                        ),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '个人简介',
                            style: TextStyle(fontSize: 14, color: Color(0xFF374151)),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _bio,
                            maxLines: 4,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.roseBorder),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Shader _brandShader(Rect bounds) {
  return AppTheme.brandGradient.createShader(bounds);
}

class _Section extends StatelessWidget {
  const _Section({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: children),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.child,
    this.showDivider = true,
  });

  final String label;
  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                ),
              ),
              Expanded(
                child: Align(alignment: Alignment.centerRight, child: child),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.border),
      ],
    );
  }
}
