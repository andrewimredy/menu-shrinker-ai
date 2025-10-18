.DEFAULT_GOAL := gen

gen:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ---------------------- Create files --------------------------"
	fvm dart run build_runner build
	@echo "╠ -------------------------- FINISH ----------------------------"

gen-force:
	@echo "╠ ------------------------- START ------------------------------"
	@echo "╠ ------------------- Force-Create files -----------------------"
	fvm dart run build_runner build --delete-conflicting-outputs
	@echo "╠ -------------------------- FINISH ----------------------------"

clean-get:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ----------------- Clean and get dependencies -----------------"
	fvm flutter clean && fvm flutter pub get
	@echo "╠ -------------------------- FINISH ----------------------------"


add-feature:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ --------------------- Add feature $(name)---------------------"
	mason make feature --name $(name) -o ./lib/feature
	make gen
	@echo "╠ -------------------------- FINISH ----------------------------"

add-dto:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ----------------------- Add dto $(name)-----------------------"
	mason make dto --name $(name) -o ./lib/common/network/dto
	make gen
	@echo "╠ -------------------------- FINISH ----------------------------"

add-api:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ----------------------- Add api $(name)-----------------------"
	mason make api --name $(name) -o ./lib/common/network/api
	make gen
	@echo "╠ -------------------------- FINISH ----------------------------"


add-repository:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ----------------------- Add Repository $(name)----------------"
	mason make repository --name $(name) -o ./lib/common/repository
	make gen
	@echo "╠ -------------------------- FINISH ----------------------------"

bootstrap:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ------------------------ Bootstrap ---------------------------"
	sh ./.scripts/bootstrap.sh -fv 3.10.6
	@echo "╠ -------------------------- FINISH ----------------------------"

appbundle:
	@echo "╠ -------------------------- START -----------------------------"
	@echo "╠ ------------------------ App bundle --------------------------"
	fvm flutter build appbundle --release
	@echo "╠ -------------------------- FINISH ----------------------------"

# iOS specific. Run these only on MacOS.
# Sometimes correct installation requires clearing build folder using
# XCode or clearing build cache using macos system settings.
pod-install:
	cd ios; pod install

pod:
	cd ios; pod install --repo-update

clean-pods: clean-pod-lock clean-pods-folder

clean-pod-lock:
	rm -rf ./ios/Podfile.lock

clean-pods-folder:
	rm -rf ./ios/Pods

clean-pod-install: clean clean-pods pod-install
clean-pod-install-update: clean clean-pods pod-update