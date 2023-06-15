import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/blocs/alerts/alerts_bloc.dart';
import 'package:smartcam_dashboard/blocs/cubit/update_alert_state_cubit.dart';
import 'package:smartcam_dashboard/blocs/filter/filter_bloc.dart';
import 'package:smartcam_dashboard/blocs/filter_data/filter_data_bloc.dart';
import 'package:smartcam_dashboard/data/api/api_client.dart';
import 'package:smartcam_dashboard/data/api/service/api_service.dart';
import 'package:smartcam_dashboard/data/api/service/api_service_impl.dart';
import 'package:smartcam_dashboard/data/fcm_handler.dart';
import 'package:smartcam_dashboard/data/models/appilied_filters.dart';
import 'package:smartcam_dashboard/data/models/filter_data.dart';
import 'package:smartcam_dashboard/data/models/filter_option.dart';
import 'package:smartcam_dashboard/data/repositories/alert_repository.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/data/repositories/cognito_auth_repository.dart';
import 'package:smartcam_dashboard/data/repositories/repository.dart';
import 'package:smartcam_dashboard/navigation/args.dart';
import 'package:smartcam_dashboard/views/alert_details_screen/alert_detail_screen.dart';
import 'package:smartcam_dashboard/views/all_alerts_screen/components/alert_tile.dart';
import 'package:smartcam_dashboard/views/all_alerts_screen/components/filter_sheet.dart';
import 'package:smartcam_dashboard/views/components/exa_app_bar.dart';
import 'package:smartcam_dashboard/utils/utils.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late final AlertsBloc _alertsBloc;
  late final Repository _alertRepository;
  late final ApiService _apiService;
  late final ApiClient _apiClient;
  late final FilterBloc _filterBloc;
  late final FilterDataBloc _filterDataBloc;
  late final UpdateAlertStateCubit _updateAlertStateCubit;
  @override
  void initState() {
    super.initState();

    _apiClient = ApiClient();
    _apiService = ApiServiceImpl(_apiClient);
    _alertRepository = AlertRepository(_apiService);
    _alertsBloc = AlertsBloc(alertRepository: _alertRepository);
    _filterBloc = FilterBloc(alertsBloc: _alertsBloc);
    _alertsBloc.add(GetAlertsEvent());
    _filterDataBloc = FilterDataBloc(repository: _alertRepository);
    _filterDataBloc.add(GetFilterData());
    _updateAlertStateCubit = UpdateAlertStateCubit(_alertRepository);
    FCMHandler.instance.initAlertsBloc(_alertsBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ExaAppBar(
        showLogOutButton: true,
      ),
      body: BlocBuilder<AlertsBloc, AlertsState>(
        bloc: _alertsBloc,
        builder: (context, state) {
          if (state is AlertsLoadedState) {
            final alerts = state.alerts;
            return RefreshIndicator(
              onRefresh: () async {
                _alertsBloc.add(GetAlertsEvent());
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                      child: BlocBuilder(
                    builder: (context, dataState) {
                      if (dataState is FilterDataLoaded) {
                        return BlocBuilder<FilterBloc, FilterState>(
                            bloc: _filterBloc,
                            builder: (context, state) {
                              AppiliedFilters appiliedFilters =
                                  AppiliedFilters.emptyFromFilterData(
                                      dataState.filterData);

                              if (state is FilterChanged) {
                                appiliedFilters = state.filters;
                              }
                              List<String> allTypesOfSelectedFilters = [];
                              for (var element
                                  in appiliedFilters.selectedFilters) {
                                allTypesOfSelectedFilters
                                    .addAll(element.selectedFilters);
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: ElevatedButton.icon(
                                        onPressed: () => showFilterSheet(
                                            dataState.filterData,
                                            appiliedFilters),
                                        icon: const Icon(Icons.filter_list,
                                            color: Colors.black),
                                        label: const Text(
                                          'Filters',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Colors.black12,
                                            ),
                                            elevation: MaterialStateProperty
                                                .all<double>(0)),
                                      ),
                                    ),
                                    ...allTypesOfSelectedFilters
                                        .map(
                                          (e) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Chip(
                                              label: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList()
                                  ],
                                ),
                              );
                            });
                      } else {
                        return Container();
                      }
                    },
                    bloc: _filterDataBloc,
                  )),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return AlertTile(
                        key: ValueKey(state.alerts[index].uid),
                        alert: state.alerts[index],
                        updateAlertStateCubit: _updateAlertStateCubit,
                      );
                    }, childCount: alerts.length),
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }

  showFilterSheet(FilterData filterData, AppiliedFilters appiliedFilters) {
    showModalBottomSheet(
      barrierColor: Colors.white,
      backgroundColor: Colors.white,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Scaffold(
        appBar: const ExaAppBar(),
        backgroundColor: Colors.white,
        body: DraggableScrollableSheet(
          initialChildSize: 1,
          expand: true,
          builder: (sheetContext, scrollController) => FilterSheet(
              filterData: filterData,
              globallyAppiliedFilters: appiliedFilters,
              filterBloc: _filterBloc),
        ),
      ),
    );
  }
}
