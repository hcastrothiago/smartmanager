import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExportService {
  static Future<void> exportToPdf(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Exportando PDF..."),
        backgroundColor: Colors.blueAccent,
      ),
    );

    final pdf = pw.Document();
    final db = FirebaseFirestore.instance;

    try {
      // Carrega uma fonte com suporte Unicode (Roboto) de forma dinâmica
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();

      final finances = await db
          .collection('financial_entries')
          .where('userId', isEqualTo: user.uid)
          .get();
      final workouts = await db
          .collection('gym_workouts')
          .where('userId', isEqualTo: user.uid)
          .get();
      final shopping = await db
          .collection('shopping_lists')
          .where('userId', isEqualTo: user.uid)
          .get();

      pdf.addPage(
        pw.MultiPage(
          // Define a fonte padrão para toda a página
          theme: pw.ThemeData.withFont(base: font, bold: boldFont),
          build: (pw.Context context) => [
            pw.Header(
              level: 0,
              child: pw.Text("Relatorio SmartManager - 2026"),
            ),

            pw.Header(level: 1, child: pw.Text("Financas")),
            ...finances.docs.map((e) {
              final data = e.data();
              return pw.Bullet(
                text:
                    "${data['description'] ?? 'Sem desc.'} - R\$ ${data['value'] ?? '0.00'}",
              );
            }),

            pw.Header(level: 1, child: pw.Text("Treinos")),
            ...workouts.docs.map((e) {
              final data = e.data();
              return pw.Bullet(
                text:
                    "${data['exercicio'] ?? 'Treino'} - ${data['calorias'] ?? 0} kcal",
              );
            }),

            pw.Header(level: 1, child: pw.Text("Dietas")),
            ...shopping.docs.map((e) {
              final data = e.data();
              return pw.Bullet(
                text:
                    "${data['tipoDieta'] ?? 'Dieta'}: ${data['dieta'] ?? 'Sem detalhes'}",
              );
            }),
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (format) => pdf.save());
    } catch (e) {
      debugPrint("Erro na exportação: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao gerar PDF: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
