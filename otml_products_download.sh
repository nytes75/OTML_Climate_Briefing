#!/usr/bin/env bash

#===Github:@nytes75=============================================
#  ___ _____ __  __ _       ____       _       __ _
# / _ \_   _|  \/  | |     | __ ) _ __(_) ___ / _(_)_ __   __ _
#| | | || | | |\/| | |     |  _ \| '__| |/ _ \ |_| | '_ \ / _` |
#| |_| || | | |  | | |___  | |_) | |  | |  __/  _| | | | | (_| |
# \___/ |_| |_|  |_|_____| |____/|_|  |_|\___|_| |_|_| |_|\__, |
#                                                         |___/

export DL_DIR=./downloads
download_access=true                # Default: true
download_access_rain_terciles=true  # Default: true
download_access_mjo=true            # Default: true

function check_folder() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"  # Use -p to create parent directories if they don't exist
    chmod -R 775 "$1"
  fi
}

function validate_url() {
  if wget --spider "$1"; then
    return 0
  else
    return 1
  fi
}

# ACCESS-S Products
if [ "$download_access" = true ]; then
  if [ "$download_access_rain_terciles" = true ]; then
    domain=PNG_crews
    # rain terciles
    check_folder "${DL_DIR}/rain_forecast/monthly/$domain"
    check_folder "${DL_DIR}/rain_forecast/seasonal/$domain"
    check_folder "${DL_DIR}/rain_forecast/weekly/$domain"
    # Download Products from BOM website:
    # rain terciles
    wget -r --no-parent --no-directories -N -R index.html* "http://access-s.clide.cloud/files/project/PNG_crews/ACCESS_S-outlooks/$domain/monthly/forecast/" -P "${DL_DIR}/rain_forecast/monthly/" -A "rain.forecast.terciles.*.png"
    wget -r --no-parent --no-directories -N -R index.html* "http://access-s.clide.cloud/files/project/PNG_crews/ACCESS_S-outlooks/$domain/seasonal/forecast/" -P "${DL_DIR}/rain_forecast/seasonal/" -A "rain.forecast.terciles.*.png"
    wget -r --no-parent --no-directories -N -R index.html* "http://access-s.clide.cloud/files/project/PNG_crews/ACCESS_S-outlooks/$domain/weekly/forecast/" -P "${DL_DIR}/rain_forecast/weekly/" -A "rain.forecast.terciles.*.png"
  fi # END rain terciles

  if [ "$download_access_mjo" = true ]; then
    domain=mjo
    # ACCESS MJO
    check_folder "${DL_DIR}/$domain"
    wget -r --no-parent --no-directories -N -R index.html* "http://access-s.clide.cloud/files/climate_drivers/mjo/" -P "${DL_DIR}/$domain" -A "*.png"
  fi
fi

