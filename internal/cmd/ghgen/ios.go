package main

//
// Generates iOS workflow.
//

import (
	"io"
	"strings"

	"github.com/ooni/probe-cli/v3/internal/runtimex"
)

func buildAndPublishMobileIOS(w io.Writer, job *Job) {
	runtimex.Assert(len(job.ArchsMatrix) <= 0, "expected no architecture matrix")

	buildJob := "build_ios_mobile"
	artifacts := []string{
		"./MOBILE/ios/libcrypto.xcframework.zip",
		"./MOBILE/ios/libcrypto.podspec",
		"./MOBILE/ios/libevent.xcframework.zip",
		"./MOBILE/ios/libevent.podspec",
		"./MOBILE/ios/libssl.xcframework.zip",
		"./MOBILE/ios/libssl.podspec",
		"./MOBILE/ios/libtor.xcframework.zip",
		"./MOBILE/ios/libtor.podspec",
		"./MOBILE/ios/libz.xcframework.zip",
		"./MOBILE/ios/libz.podspec",
		"./MOBILE/ios/oonimkall.xcframework.zip",
		"./MOBILE/ios/oonimkall.podspec",
	}
	swiftPackage := "./MOBILE/ios/Package.swift"

	// We publish to the GitHub release from the build job, where the
	// .xcframework zips and the Package.swift that pins their checksums
	// already exist, rather than downloading them into a separate job.
	newJob(w, buildJob, runsOnMacOS, noDependencies, contentsWritePermissions)
	newStepCheckout(w)
	newStepSetupGo(w, "ios")
	iosNewStepBrewInstall(w)
	newStepMake(w, "EXPECTED_XCODE_VERSION=16.4 ios")
	iosNewStepGHPublish(w, append(append([]string{}, artifacts...), swiftPackage))

	// The Maven publishing jobs consume these artifacts.
	newStepUploadArtifacts(w, artifacts)
}

// iosNewStepGHPublish is like newStepGHPublish but uploads the files from
// where the build job created them rather than from the working directory.
func iosNewStepGHPublish(w io.Writer, files []string) {
	runtimex.Assert(len(files) > 0, "expected at least one file")
	mustFprintf(w, "      - run: ./script/ghpublish.bash %s\n", strings.Join(files, " "))
	mustFprintf(w, "        env:\n")
	mustFprintf(w, "          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}\n")
	mustFprintf(w, "\n")
}

func iosNewStepBrewInstall(w io.Writer) {
	mustFprintf(w, "      # ./internal/cmd/buildtool needs coreutils for sha256 plus GNU build tools\n")
	mustFprintf(w, "      - run: brew install autoconf automake coreutils libtool\n")
	mustFprintf(w, "\n")
}
