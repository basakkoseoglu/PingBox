import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiyatalarm/services/MessageService.dart';
import 'package:flutter/material.dart';

class EditMessageModal extends StatefulWidget {
  final DocumentSnapshot doc;

  const EditMessageModal({super.key, required this.doc});

  @override
  State<EditMessageModal> createState() => _EditMessageModalState();
}

class _EditMessageModalState extends State<EditMessageModal> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  late DateTime _sendAt;

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}."
        "${date.month.toString().padLeft(2, '0')}."
        "${date.year}  "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

 @override
void initState() {
  super.initState();

  final data = widget.doc.data() as Map<String, dynamic>;

  _titleController = TextEditingController(text: data["title"]);
  _contentController = TextEditingController(text: data["content"]);
  final rawSendAt = data["sendAt"];
  if (rawSendAt is Timestamp) {
    _sendAt = rawSendAt.toDate();
  } else {
    _sendAt = DateTime.now();
  }
}

  Future<void> pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _sendAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _sendAt = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          _sendAt.hour,
          _sendAt.minute,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_sendAt),
    );

    if (selectedTime != null) {
      setState(() {
        _sendAt = DateTime(
          _sendAt.year,
          _sendAt.month,
          _sendAt.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mesajı Düzenle",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDate(_sendAt),
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Başlık",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Mesaj İçeriği",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          "Tarih: ${_sendAt.day}.${_sendAt.month}.${_sendAt.year}",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                InkWell(
                  onTap: pickTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: colorScheme.primary),
                        const SizedBox(width: 10),
                        Text(
                          "Saat: ${_sendAt.hour.toString().padLeft(2, '0')}:${_sendAt.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                InkWell(
                  onTap: () async {
                    await MessageService().updateMessage(
                      widget.doc.id,
                      title: _titleController.text,
                      content: _contentController.text,
                      sendAt: _sendAt,
                    );

                    if (mounted) Navigator.pop(context, true);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colorScheme.primary.withOpacity(0.12),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          "Güncelle",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
