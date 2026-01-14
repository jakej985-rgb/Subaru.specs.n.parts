# File Index 🗂️

A map of the important code, data, test, and tooling areas.

## App Core

- `lib/app.dart`
- `lib/main.dart`: App entry point

## Routing

- `lib/router/app_router.dart`: Routing configuration

## Features

- `lib/features/browse_engine/engine_flow_page.dart`
- `lib/features/browse_ymm/ymm_flow_page.dart`
- `lib/features/comparison/comparison_page.dart`
- `lib/features/comparison/comparison_provider.dart`
- `lib/features/global_search/global_search_overlay.dart`
- `lib/features/global_search/global_search_provider.dart`
- `lib/features/home/garage_providers.dart`
- `lib/features/home/garage_view.dart`
- `lib/features/home/home_page.dart`
- `lib/features/part_lookup/part_lookup_page.dart`
- `lib/features/part_lookup/part_search_provider.dart`
- `lib/features/part_lookup/widgets/part_dialog.dart`
- `lib/features/settings/settings_page.dart`
- `lib/features/specs/spec_list_controller.dart`
- `lib/features/specs/spec_list_page.dart`
- `lib/features/specs_by_category/category_year_picker_page.dart`
- `lib/features/specs_by_category/category_year_results_controller.dart`
- `lib/features/specs_by_category/category_year_results_page.dart`
- `lib/features/specs_by_category/spec_category_keys.dart`
- `lib/features/specs_by_category/specs_by_category_hub_page.dart`
- `lib/features/vin_wizard/vin_decoder.dart`

## Data & Database

- `lib/data/db/app_db.dart`
- `lib/data/db/dao/parts_dao.dart`
- `lib/data/db/dao/specs_dao.dart`
- `lib/data/db/dao/vehicles_dao.dart`
- `lib/data/db/tables.dart`
- `lib/data/seed/seed_runner.dart`
- `lib/domain/fitment/fitment_key.dart`

## Seed Data

- `assets/seed/parts.json`
- `assets/seed/specs/alignment.json`: Specification seed data
- `assets/seed/specs/battery.json`: Specification seed data
- `assets/seed/specs/brakes.json`: Specification seed data
- `assets/seed/specs/bulbs.json`: Specification seed data
- `assets/seed/specs/coolant.json`: Specification seed data
- `assets/seed/specs/cooling.json`: Specification seed data
- `assets/seed/specs/differential.json`: Specification seed data
- `assets/seed/specs/dimensions.json`: Specification seed data
- `assets/seed/specs/engine.json`: Specification seed data
- `assets/seed/specs/engines.json`: Specification seed data
- `assets/seed/specs/filters.json`: Specification seed data
- `assets/seed/specs/fluids.json`: Specification seed data
- `assets/seed/specs/fuel.json`: Specification seed data
- `assets/seed/specs/index.json`: Specification seed data
- `assets/seed/specs/maintenance.json`: Specification seed data
- `assets/seed/specs/maintenance_intervals.json`: Specification seed data
- `assets/seed/specs/oil.json`: Specification seed data
- `assets/seed/specs/spark_plugs.json`: Specification seed data
- `assets/seed/specs/swap_rules.json`: Specification seed data
- `assets/seed/specs/tires.json`: Specification seed data
- `assets/seed/specs/torque.json`: Specification seed data
- `assets/seed/specs/torque_specs.json`: Specification seed data
- `assets/seed/specs/transmission.json`: Specification seed data
- `assets/seed/specs/wheels.json`: Specification seed data
- `assets/seed/vehicles.json`

## CI & Workflows


## Tooling & Scripts

- `scripts/generate_engines_csv.py`
- `scripts/generate_fluids_csv_v2.py`
- `scripts/generate_jdm_bulbs.py`
- `scripts/generate_jdm_vehicles.py`
- `scripts/generate_torque_specs_csv.py`
- `scripts/lumen_deep_resolver_v2.py`
- `scripts/validate_engines_csv.py`
- `tool/seed/sync_fitment_csv_to_specs_json.dart`
- `tool/seed/sync_fitment_csv_to_specs_json.py`: Syncs CSV fitment data to JSON specs (CI check)
- `tool/seed/test_sync_fitment.py`

## Tests

- `test/data/db/dao/specs_dao_test.dart`
- `test/data/db/dao/vehicles_dao_test.dart`
- `test/data/seed/brz_2024_coverage_test.dart`
- `test/data/seed/brz_full_history_test.dart`
- `test/data/seed/forester_classic_validation_test.dart`
- `test/data/seed/forester_gen5_validation_test.dart`
- `test/data/seed/forester_modern_validation_test.dart`
- `test/data/seed/impreza_gen1_validation_test.dart`
- `test/data/seed/impreza_gen2_validation_test.dart`
- `test/data/seed/legacy_validation_test.dart`
- `test/data/seed/outback_gen4_validation_test.dart`
- `test/data/seed/outback_modern_validation_test.dart`
- `test/data/seed/outback_separation_validation_test.dart`
- `test/data/seed/seed_parsing_test.dart`
- `test/data/seed/specs_baja_coverage_test.dart`
- `test/data/seed/specs_comprehensive_audit_test.dart`
- `test/data/seed/specs_forester_gen1_coverage_test.dart`
- `test/data/seed/specs_forester_gen2_coverage_test.dart`
- `test/data/seed/specs_forester_gen3_coverage_test.dart`
- `test/data/seed/specs_format_audit_test.dart`
- `test/data/seed/specs_impreza_gd_fluids_test.dart`
- `test/data/seed/specs_impreza_gen1_coverage_test.dart`
- `test/data/seed/specs_impreza_gen2_coverage_test.dart`
- `test/data/seed/specs_impreza_gen3_coverage_test.dart`
- `test/data/seed/specs_legacy_coverage_test.dart`
- `test/data/seed/specs_legacy_gen2_coverage_test.dart`
- `test/data/seed/specs_legacy_gen3_coverage_test.dart`
- `test/data/seed/specs_legacy_gen4_coverage_test.dart`
- `test/data/seed/specs_modern_coverage_test.dart`
- `test/data/seed/specs_outback_gen3_coverage_test.dart`
- `test/data/seed/specs_outback_gen4_coverage_test.dart`
- `test/data/seed/specs_sti_2004_wheels_test.dart`
- `test/data/seed/specs_subaru_classic_coverage_test.dart`
- `test/data/seed/specs_wrx_gen2_coverage_test.dart`
- `test/data/seed/specs_wrx_sti_gen2_coverage_test.dart`
- `test/data/seed/split_era_validation_test.dart`
- `test/data/seed/vehicles_validation_test.dart`
- `test/data/seed/wrx_2024_coverage_test.dart`
- `test/db_test.dart`
- `test/features/browse_ymm/browse_ymm_race_test.dart`
- `test/features/browse_ymm/ymm_flow_page_semantics_test.dart`
- `test/features/browse_ymm/ymm_flow_page_test.dart`
- `test/features/global_search/global_search_test.dart`
- `test/features/home/garage_providers_test.dart`
- `test/features/home/home_scroll_test.dart`
- `test/features/part_lookup/part_lookup_clear_button_test.dart`
- `test/features/part_lookup/part_lookup_debounce_test.dart`
- `test/features/part_lookup/part_lookup_empty_state_test.dart`
- `test/features/part_lookup/part_lookup_security_test.dart`
- `test/features/part_lookup/part_lookup_suggestions_test.dart`
- `test/features/part_lookup/part_search_provider_test.dart`
- `test/features/specs/brz_2022_specs_test.dart`
- `test/features/specs/coverage_audit_test.dart`
- `test/features/specs/spec_list_debounce_test.dart`
- `test/features/specs/spec_list_empty_state_test.dart`
- `test/features/specs/spec_list_interaction_test.dart`
- `test/features/specs/spec_list_pagination_test.dart`
- `test/features/specs/specs_coverage_test.dart`
- `test/features/specs_by_category/category_results_test.dart`
- `test/features/vin_wizard/vin_wizard_test.dart`
- `test/smoke_test.dart`
- `test/specs_applicability_test.dart`
- `test/tool/seed_sync_test.dart`
- `test/widget_test.dart`
- `test/widgets/app_initialization_test.dart`
- `test/widgets/home_menu_card_semantics_test.dart`

## Documentation

- `projects/repo_scribe/artifacts/ENTRYPOINTS_AND_CALLS.md`
- `projects/repo_scribe/artifacts/FILE_INDEX.md`
- `projects/repo_scribe/artifacts/FULL_REPO_INVENTORY.md`
- `projects/repo_scribe/artifacts/GENERATED_AND_IGNORED_FOLDERS.md`
- `projects/repo_scribe/artifacts/ONBOARDING_CHEATSHEET.md`
- `projects/repo_scribe/artifacts/UNUSED_FILE_CANDIDATES.md`
- `projects/repo_scribe/artifacts/inventory.json`
- `projects/repo_scribe/docs_generator.py`
- `projects/repo_scribe/inventory_generator.py`
