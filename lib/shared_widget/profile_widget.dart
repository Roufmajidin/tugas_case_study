
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.nama,
    required this.jabatan,
    // ignore: non_constant_identifier_names
    required this.kode_gudang,
  });
  final String nama;
  final bool jabatan;
  final String kode_gudang;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(50), // Add border
          ),
          child: const ClipRect(
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back, $nama",
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text("Admin Gudang : $kode_gudang"),
            ],
          ),
        ),
      ],
    );
  }
}