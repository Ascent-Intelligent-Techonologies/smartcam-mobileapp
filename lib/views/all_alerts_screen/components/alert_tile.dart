import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smartcam_dashboard/blocs/cubit/update_alert_state_cubit.dart';
import 'package:smartcam_dashboard/data/models/alert.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';
import 'package:smartcam_dashboard/navigation/args.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/alert_details_screen/alert_detail_screen.dart';

class AlertTile extends StatefulWidget {
  final Alert alert;
  final UpdateAlertStateCubit updateAlertStateCubit;
  const AlertTile(
      {super.key, required this.alert, required this.updateAlertStateCubit});

  @override
  State<AlertTile> createState() => _AlertTileState();
}

class _AlertTileState extends State<AlertTile> {
  bool isSeen = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: (widget.alert.isNew ?? false) && !isSeen
            ? Theme.of(context).primaryColor.withOpacity(.1)
            : Colors.white,
        onTap: () {
          widget.updateAlertStateCubit.updateAlertState(UpdateAlertStateModel(
            uid: widget.alert.uid ?? "",
            updateKey: 'is_new',
            updateValue: 0,
          ));
          setState(() {
            isSeen = true;
          });
          Navigator.pushNamed(
            context,
            AlertDetailScreen.routeName,
            arguments: AlertDetailScreenArguments(alert: widget.alert),
          );
        },
        title: Row(
          children: [
            Text(
              widget.alert.category,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.alert.datetime.readableString(),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        subtitle: Text(widget.alert.deviceName ?? ""),
        trailing:
            Icon(Icons.play_circle, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
