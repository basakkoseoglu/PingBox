import 'package:flutter/material.dart';
import 'package:pingbox/components/Diaologs/CustomConfirmDialog.dart';
import 'package:pingbox/components/MessageCompose/DateTimePicker.dart';
import 'package:pingbox/components/MessageCompose/SaveButton.dart';
import 'package:pingbox/components/MessageCompose/TextField.dart';
import 'package:pingbox/providers/MessageProvider.dart';
import 'package:provider/provider.dart';

class MessageComposeScreen extends StatefulWidget {
  const MessageComposeScreen({super.key});

  @override
  State<MessageComposeScreen> createState() => _MessageComposeScreenState();
}

class _MessageComposeScreenState extends State<MessageComposeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isSaving = false;

  Future<void> saveMessage() async {
    if (isSaving) return; //aynı anda iki kere tıklamayı engeller

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mesaj boş olamaz!")));
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tarih ve saat seçin.")),
      );
      return;
    }

    setState(() => isSaving = true);

    final sendAt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final success = await context.read<MessageProvider>().addMessage(
      title: _titleController.text,
      content: _contentController.text,
      sendAt: sendAt,
    );

    setState(() => isSaving = false);

    if (success && mounted) {
      setState(() {
        _titleController.clear();
        _contentController.clear();
        selectedDate = null;
        selectedTime = null;
      });

      await AppDialogs.show(
        context,
        title: "Mesajınız Oluşturuldu!",
        message:
            "İstediğiniz zamanda mesajınız size ulaşmak üzere kaydedilmiştir!",
        primaryButton: "Tamam",
        secondaryButton: null,
      );

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else if (mounted) {
      await AppDialogs.show(
        context,
        title: "Hata",
        message: "Mesaj kaydedilemedi",
        primaryButton: "Tamam",
        secondaryButton: null,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Yeni Mesaj Oluştur',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Mesaj Başlığı',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _contentController,
                labelText: 'Mesajını Yaz...',
                maxLines: 7,
              ),
              const SizedBox(height: 24),
              DateTimePicker(
                selectedDate: selectedDate,
                selectedTime: selectedTime,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustomSaveButton(onPressed: saveMessage, isSaving: isSaving),
            ],
          ),
        ),
      ),
    );
  }
}
