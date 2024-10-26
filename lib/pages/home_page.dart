import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/util/habit_util.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(context),
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ],
      ),
    );
  }

  @override
  void initState() {
    Provider.of<HabitDb>(context, listen: false).readHabits();

    super.initState();
  }

  bool? checkBoxOnOff(bool? p0, Habit habit) {
    if (p0 != null) {
      context.read<HabitDb>().updateHabitCompletion(habit.id, p0);
    }
    return null;
  }

  void editHabit(BuildContext context, Habit habit) {
    textEditingController.text = habit.habitName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Edit habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabit = textEditingController.text;
              context.read<HabitDb>().updateHabitName(habit.id, newHabit);
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void dltHabit(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDb>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDb>();
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompleted(habit.completedDays);
        return MyHabitTile(
          isCompleted: isCompletedToday,
          text: habit.habitName,
          onChanged: (p0) => checkBoxOnOff(p0, habit),
          editHabit: (context) => editHabit(context, habit),
          dltHabit: (context) => dltHabit(context, habit),
        );
      },
    );
  }

  final TextEditingController textEditingController = TextEditingController();

  void createNewHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabit = textEditingController.text;
              context.read<HabitDb>().addHabit(newHabit);
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDb = context.watch<HabitDb>();
    List<Habit> currentHabit = habitDb.currentHabits;
    return FutureBuilder(
      future: habitDb.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              dataSet: prepHeatMapDataset(currentHabit));
        } else {
          return Container();
        }
      },
    );
  }
}
