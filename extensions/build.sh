#!/bin/bash

# SPDX-FileCopyrightText: 2023 Deutsche Telekom AG
#
# SPDX-License-Identifier: CC-BY-4.0
# SPDX-License-Identifier: CC0-1.0

LIBS_DIR="./../providers"

function init() {
  mkdir -p "$LIBS_DIR"
}

function build_keycloak_metrics_spi_extension() {
  EXTENSION_NAME="keycloak-metrics-spi"

  KEYCLOAK_VERSION="21.1.2"
  PROMETHEUS_JAVA_SIMPLECLIENT_VERSION="0.16.0"

  pushd "$EXTENSION_NAME"
    ./gradlew -PkeycloakVersion="$KEYCLOAK_VERSION" -PprometheusVersion="$PROMETHEUS_JAVA_SIMPLECLIENT_VERSION" clean build jar

    if [ $? -ne 0 ]; then FAILED=true; fi 
  popd

  if [ -n "$FAILED" ]; then 
    echo
    echo "Error: Failed to build extension $EXTENSION_NAME"
    echo 

    exit 1
  fi

  cp -a "$EXTENSION_NAME/build/libs/." "$LIBS_DIR/"
}

init && \
build_keycloak_metrics_spi_extension
