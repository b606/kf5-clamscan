#!/bin/bash

# TODO: script echos new-lines, why?

language=$1
if [ "${language}" == "" ]; then language="en"; fi
lang_l="$(echo ${#language}+2 | bc)"
files_old=$*
IFS="," #new separator instead of spaces
files=${files_old//\ \//,\/} #from " /" to ",/"
version="2.5.5"
title="ClamScan $version"
date="$(date +"%H-%M-%S_%d-%m-%Y")"
path="$(kf5-config --path services)"
spath="$(echo ${path%:*})"
error_sentence="No files selected." #english
empty="0"
if [ $language = "de" ]; then
  wait="ClamAV scannt, bitte warten."
  not_found="ClamAV ist nicht installiert!"
  scan_sentence="Scannen von Dateien: "
elif [ $language = "en" ]; then
  wait="ClamAV is scanning, please wait."
  not_found="ClamAV is not installed!"
  scan_sentence="Scanning files: "
elif [ $language = "fi" ]; then
  wait="ClamAV tarkistaa valittuja tiedostoja, odota hetki."
  not_found="ClamAV:a ei ole asennettu!"
  scan_sentence="Tiedostojen skannauksen: "
elif [ $language = "fr" ]; then
  wait="ClamAV analyse, veuillez patienter."
  not_found="ClamAV n'est pas installé!"
  scan_sentence="Analyse des fichiers: "
elif [ $language = "id" ]; then
  wait="ClamAV sedang mengecek, silakan tunggu."
  not_found="ClamAV tidak terpasang"
  scan_sentence="Scanning file: "
elif [ $language = "it" ]; then
  wait="ClamAV sta scansionando, attendi per favore."
  not_found="ClamAV non è installato!"
  scan_sentence="Scansione dei file: "
elif [ $language = "ru" ]; then
  wait="ClamAV проводит сканирование. Пожалуйста, подождите."
  not_found="ClamAV не установлен!"
  scan_sentence="Сканирование файлов: "
elif [ $language = "sv" ]; then
  wait="ClamAV skannar, vänta."
  not_found="ClamAV verkar inte vara installerat!"
  scan_sentence="Scanning filer: "
elif [ $language = "tr" ]; then
  wait="ClamAV tarıyor, lütfen bekleyin."
  not_found="ClamAV kurulu değil!"
  scan_sentence="Tarama Dosyaları: "
elif [ $language = "uk" ]; then
  wait="ClamAV проводить сканування. Будь ласка, зачекайте."
  not_found="ClamAV не встановлено!"
  scan_sentence="Сканування файлів: "
elif [ $language = "es" ]; then
  wait="ClamAV está escaneando. Por favor espere..."
  not_found="ClamAV no está instalado!"
  scan_sentence="Comprobando archivos: "
else 
  wait="ClamAV is scanning, please wait."
  not_found="ClamAV is not installed!"
  scan_sentence="Scanning files: "
fi
log_dir="$spath"ServiceMenus/ClamScan/logs/
if [ -f /usr/bin/clamscan ]; then
  if [ ! -d $log_dir ]; then 
    mkdir $log_dir
  fi
  real_files="$(echo "$files" | cut -c $lang_l-)"
  complete_amount="$(find -L $files -type f | wc -l)"
  complete_amount_dir="$(find -L $files -type d | wc -l)"
  
  if  [ $complete_amount = "0" ]; then 
    if  [ $complete_amount_dir = "0" ]; then
      empty="1"
    fi
  fi
  
  if  [ $empty != "1" ]; then
    echo "Result:" > "$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log
    nohup clamscan -r --log="$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log --stdout $real_files > "$spath"/ServiceMenus/ClamScan/logs/ClamScan_$date.log 2>&1 &
    current_lines="0"

    progress=$(kdialog --title "$title" --progressbar "$wait 
$scan_sentence $complete_amount ($complete_amount_dir directories)")

  else
    echo "$error_sentence" >> "$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log
  fi
  if  [ "${empty}" != "1"  ]; then
    IFS=" " #Necessary, progressbar wouldn't work without it
    qdbus $progress org.kde.kdialog.ProgressDialog.showCancelButton "true"
    checklines="$(expr $current_lines \> $complete_amount)"
    while [ $checklines != "1"  ]; do
      cancelled=$(qdbus $progress org.kde.kdialog.ProgressDialog.wasCancelled)
      if [ "${cancelled}" = "true" ]; then
        qdbus $progress org.kde.kdialog.ProgressDialog.close
        break
      fi
      # TODO: if cancelled don't do this (or break before it)
      qdbus $progress org.kde.kdialog.ProgressDialog.setLabelText "$wait 
$scan_sentence $current_lines/$complete_amount ($complete_amount_dir directories)"
      qdbus $progress Set org.kde.kdialog.ProgressDialog value  $(expr $current_lines \* 100 / $complete_amount)
      current_lines="$(cat "$spath"/ServiceMenus/ClamScan/logs/ClamScan_$date.log | wc -l)"
      checklines="$(expr $current_lines \> $complete_amount)"
      sleep 0.25
    done

    if [ "${cancelled}" != "true" ]; then
      qdbus $progress org.kde.kdialog.ProgressDialog.setLabelText "Finished"
      qdbus $progress org.kde.kdialog.ProgressDialog.close
    fi
    
    if [ -f "$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log ]; then 
      if [ $checklines = "1" ]; then
	kdialog --title "$title" --textbox "$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log 500 400
	rm "$spath"/ServiceMenus/ClamScan/logs/ClamScan_$date.log
      else kill $!
      fi
    fi
  else
    kdialog --title "$title" --textbox "$spath"/ServiceMenus/ClamScan/logs/ClamScan_result_$date.log 500 400
  fi

else kdialog --title "$title" --msgbox "$not_found"
fi
