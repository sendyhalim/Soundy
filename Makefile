platform = --platform macos
xcode_flags = -project "Soundy.xcodeproj" -scheme "Soundy" -configuration "Release" DSTROOT=/tmp/Soundy.dst
xcode_flags_test = -project "Soundy.xcodeproj" -scheme "Soundy" -configuration "Debug"
components_plist = "Supporting Files/Components.plist"
temporary_dir = /tmp/Soundy.dst
output_package_name = Soundy.pkg

bootstrap:
	carthage bootstrap $(platform)

update:
	carthage update $(platform)

build:
	carthage build $(platform)

synx:
	synx Soundy.xcodeproj

clean:
	rm -rf $(temporary_dir)
	rm -f $(output_package_name)
	xcodebuild $(xcode_flags) clean

test: clean
	xcodebuild $(xcode_flags_test) test

installables: clean bootstrap
	xcodebuild $(xcode_flags) install

lint:
	swiftlint

package: installables
	pkgbuild \
		--component-plist $(components_plist) \
		--identifier "com.sendyhalim.soundy" \
		--install-location "/" \
		--root $(temporary_dir) \
		$(output_package_name)


.PHONY: bootstrap update synx clean test installables lint package
