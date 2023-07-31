cleanup:
	fvm flutter clean && fvm flutter pub get && fvm flutter pub run build_runner build --delete-conflicting-outputs

locale:
	fvm flutter pub run easy_localization:generate -S assets/locale -f keys -O lib/core/locale -o locale_keys.g.dart

runner:
	fvm flutter pub run build_runner build --delete-conflicting-outputs
runner-watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

build-web:
	fvm flutter build web
deploy-web:
	make cleanup && make locale && make build-web && firebase deploy