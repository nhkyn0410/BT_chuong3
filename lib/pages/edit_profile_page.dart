import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_profile.dart';
import '../widgets/profile_avatar.dart';

/// Màn hình nhập/chỉnh sửa hồ sơ. Nhận hồ sơ hiện tại qua [initialProfile] và
/// trả hồ sơ mới về màn hình trước bằng `Navigator.pop(context, profile)`.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.initialProfile});

  final UserProfile initialProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final _fullName = TextEditingController(
    text: widget.initialProfile.fullName,
  );
  late final _studentId = TextEditingController(
    text: widget.initialProfile.studentId,
  );
  late final _className = TextEditingController(
    text: widget.initialProfile.className,
  );
  late final _email = TextEditingController(text: widget.initialProfile.email);

  var _autovalidateMode = AutovalidateMode.disabled;

  static final _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  @override
  void dispose() {
    _fullName.dispose();
    _studentId.dispose();
    _className.dispose();
    _email.dispose();
    super.dispose();
  }

  /// Bỏ khoảng trắng thừa ở đầu, cuối và giữa các từ.
  String _clean(String value) => value.trim().split(RegExp(r'\s+')).join(' ');

  UserProfile get _draft => UserProfile(
    fullName: _clean(_fullName.text),
    studentId: _studentId.text.trim().toUpperCase(),
    className: _clean(_className.text).toUpperCase(),
    email: _email.text.trim(),
  );

  void _save() {
    if (!_formKey.currentState!.validate()) {
      // Sau lần lưu lỗi đầu tiên, kiểm tra lại ngay khi người dùng sửa.
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }
    Navigator.pop(context, _draft);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Center(
                    // Ảnh đại diện cập nhật ngay khi gõ họ tên.
                    child: ListenableBuilder(
                      listenable: _fullName,
                      builder: (context, child) =>
                          ProfileAvatar(profile: _draft, radius: 44),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _fullName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên *',
                      hintText: 'VD: Nguyễn Văn An',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      final name = _clean(value ?? '');
                      if (name.isEmpty) return 'Vui lòng nhập họ và tên';
                      if (name.length < 2) return 'Họ và tên quá ngắn';
                      if (RegExp(r'\d').hasMatch(name)) {
                        return 'Họ và tên không được chứa chữ số';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studentId,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                      LengthLimitingTextInputFormatter(15),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Mã số sinh viên (MSSV) *',
                      hintText: 'VD: 2151012345',
                      prefixIcon: Icon(Icons.numbers_rounded),
                    ),
                    validator: (value) {
                      final id = value?.trim() ?? '';
                      if (id.isEmpty) return 'Vui lòng nhập MSSV';
                      if (id.length < 5) return 'MSSV phải có ít nhất 5 ký tự';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _className,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Lớp',
                      hintText: 'VD: DH21CNTT01',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.email],
                    onFieldSubmitted: (_) => _save(),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'VD: an.nguyen@example.com',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty || _emailPattern.hasMatch(email)) {
                        return null;
                      }
                      return 'Email không hợp lệ';
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '* Trường bắt buộc',
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Lưu thay đổi'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
