import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../core/widgets/custom_text_field_widget.dart';
import '../../../core/widgets/snackbar_widget.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherFailure) {
              AppSnackBar.showError(context, state.message);
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 20.0.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomTextFieldWidget(
                            controller: _cityController,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.text,
                            hintText: 'Search city/country',
                            maxLines: 1,
                            borderColor: AppColors.darkGrey,
                            onSubmitted: (value) {
                              if (value!.trim().isNotEmpty) {
                                context
                                    .read<WeatherBloc>()
                                    .add(WeatherFetchByCity(value.trim()));
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CustomButtonWidget(
                          width: 100.w,
                          title: 'Search',
                          onPressed: () {
                            final c = _cityController.text.trim();
                            if (c.isNotEmpty) {
                              context
                                  .read<WeatherBloc>()
                                  .add(WeatherFetchByCity(c));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        print('refresh');
                        final stateNow = context.read<WeatherBloc>().state;
                        if (stateNow is WeatherLoadSuccess) {
                          context.read<WeatherBloc>().add(
                              WeatherFetchByCity(stateNow.model.cityName));
                        } else {
                          context
                              .read<WeatherBloc>()
                              .add(WeatherFetchByLocation());
                        }
                        await Future.delayed(
                          const Duration(milliseconds: 500),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: _buildContent(state),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    final spinKitLoader = SpinKitPouringHourGlassRefined(
      color: AppColors.seed,
      size: 60.0.spMax,
    );
    if (state is WeatherLoading) {
      return Center(child: spinKitLoader);
    } else if (state is WeatherLoadSuccess) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildWeatherCard(state),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<WeatherBloc>().add(WeatherFetchByLocation()),
            icon: const Icon(Icons.my_location),
            label: const Text('Use my location'),
          ),
        ],
      );
    } else if (state is WeatherFailure) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () =>
                context.read<WeatherBloc>().add(WeatherFetchByLocation()),
            icon: const Icon(Icons.my_location),
            label: const Text('Use my location'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Search for weather or use your location'),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<WeatherBloc>().add(WeatherFetchByLocation()),
            icon: const Icon(Icons.my_location),
            label: const Text('Use my location'),
          ),
        ],
      );
    }
  }

  Widget _buildWeatherCard(WeatherLoadSuccess state) {
    final model = state.model;
    final iconUrl = 'https://openweathermap.org/img/wn/${model.icon}@4x.png';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.seed.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            model.cityName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Image.network(
            iconUrl,
            width: 150.w,
            height: 150.h,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            '${model.tempC.toStringAsFixed(1)} °C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48.spMax,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            model.condition,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20.spMax,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }}
