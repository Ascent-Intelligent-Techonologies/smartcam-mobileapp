import 'package:flutter/material.dart';
import 'package:smartcam_dashboard/blocs/filter/filter_bloc.dart';
import 'package:smartcam_dashboard/data/models/appilied_filters.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';

class FilterSheet extends StatefulWidget {
  final FilterData filterData;
  AppiliedFilters globallyAppiliedFilters;
  final FilterBloc filterBloc;
  FilterSheet(
      {super.key,
      required this.filterData,
      required this.globallyAppiliedFilters,
      required this.filterBloc});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int currentTab = 0;
  toggleTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1,
          height: 1,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: 4,
                  child: FilterTabs(
                      filterData: widget.filterData,
                      onPressed: toggleTab,
                      currentTab: currentTab)),
              Flexible(
                flex: 6,
                child: FiltersWrap(
                    filterOption:
                        widget.filterData.availableFilters[currentTab],
                    selectedValues: widget
                        .globallyAppiliedFilters.selectedFilters
                        .firstWhere((element) =>
                            element.value ==
                            widget
                                .filterData.availableFilters[currentTab].value),
                    filterBloc: widget.filterBloc,
                    globallyAppiliedFilters: widget.globallyAppiliedFilters),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                  bottom: BorderSide(color: Colors.grey[300]!))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      widget.filterBloc.add(ChangeFilter(
                          AppiliedFilters.emptyFromFilterData(
                              widget.filterData)));
                      setState(() {
                        widget.globallyAppiliedFilters =
                            AppiliedFilters.emptyFromFilterData(
                                widget.filterData);
                      });
                    },
                    child: const Text('Clear filters'),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class FilterTabs extends StatefulWidget {
  final FilterData filterData;
  final int currentTab;
  final Function(int) onPressed;
  const FilterTabs(
      {super.key,
      required this.filterData,
      required this.onPressed,
      required this.currentTab});

  @override
  State<FilterTabs> createState() => _FilterTabsState();
}

class _FilterTabsState extends State<FilterTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView(
          padding: EdgeInsets.zero,
          children: widget.filterData.availableFilters
              .map((e) => GestureDetector(
                    onTap: () {
                      widget.onPressed(
                          widget.filterData.availableFilters.indexOf(e));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: widget.currentTab ==
                                widget.filterData.availableFilters.indexOf(e)
                            ? Colors.white
                            : Colors.grey[200],
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          e.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}

class FiltersWrap extends StatefulWidget {
  final FilterOption filterOption;
  final FilterOptionSelectedValues selectedValues;
  final AppiliedFilters globallyAppiliedFilters;
  final FilterBloc filterBloc;
  const FiltersWrap(
      {required this.filterOption,
      required this.selectedValues,
      required this.filterBloc,
      required this.globallyAppiliedFilters});

  @override
  State<FiltersWrap> createState() => _FiltersWrapState();
}

class _FiltersWrapState extends State<FiltersWrap> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: widget.filterOption.filterData
            .map((e) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          widget.selectedValues.selectedFilters.contains(e)
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                      backgroundColor:
                          widget.selectedValues.selectedFilters.contains(e)
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (widget.selectedValues.selectedFilters.contains(e)) {
                        widget.selectedValues.selectedFilters.remove(e);
                        // globallyAppiliedFilters.selectedFilters.forEach((element) { })
                        widget.filterBloc
                            .add(ChangeFilter(widget.globallyAppiliedFilters));
                      } else {
                        widget.selectedValues.selectedFilters.add(e);

                        widget.filterBloc
                            .add(ChangeFilter(widget.globallyAppiliedFilters));
                      }
                      setState(() {});
                    },
                    child: Text(e),
                  ),
                ))
            .toList());
  }
}
