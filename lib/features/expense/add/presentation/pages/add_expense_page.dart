import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../injection_container.dart';
import '../bloc/add_expense_bloc.dart';
import '../widgets/index.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  bool _noteOpen = false;
  final _noteController = TextEditingController();
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void dispose() {
    _noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddExpenseBloc>(),
      child: BlocListener<AddExpenseBloc, AddExpenseState>(
        listenWhen: (previous, current) =>
            previous.editingEntryId != current.editingEntryId,
        listener: (context, state) {
          if (state.isEditing) {
            _noteController.text = state.note;

            setState(() => _noteOpen = state.note.isNotEmpty);
          } else {
            _noteController.clear();

            setState(() => _noteOpen = false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              children: [
                const AddExpenseHeader(key: ValueKey('header')),

                Expanded(child: AddExpenseSessionList(listKey: _listKey)),

                const Divider(
                  color: Color(0xFF12152A),
                  height: 1,
                  thickness: 1,
                ),

                AddExpenseInputPanel(
                  noteController: _noteController,
                  noteOpen: _noteOpen,
                  onToggleNote: () => setState(() => _noteOpen = !_noteOpen),
                  onAdd: () => setState(() {
                    _noteOpen = false;
                    _noteController.clear();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
