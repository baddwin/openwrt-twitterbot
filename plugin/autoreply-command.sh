#!/bin/bash
#
# nama plugin : autoreply_command
# deksripsi   : plugin tambahan untuk menentukan sebuah mention merupakan command atau bukan
#               plugin ini dipanggil lewat script autoreply.sh
#

# TODO:
# !stop
# !gombalin
# !ejekin

# list username admin, pisahkan dengan spasi
ngadimin="@gojigeje @gojibuntu"

cekngadimin() {
  if [[ "$ngadimin" == *"$twit_user"* ]]; then
    # echo "$comm_user ada di list ngadimin"
    respon="0"
    isngadimin="1"
  else
    # echo "$comm_user nggak ada di list ngadimin"
    respon="1"
    isngadimin="0"    
  fi
}

reply_command() {

  cekngadimin
  udahdibalas="0"
  comm_user="$(echo "$@" | awk '{print $1}')"
  comm_tipe="$(echo "$@" | awk '{print $3}')"
  comm_tipeisi="$(echo "$@" | cut -d " " -f 3-)"
  comm_isi="$(echo "$@" | cut -d " " -f 4-)"

  echo "comm_user    : $comm_user"
  echo "comm_tipe    : $comm_tipe"
  echo "comm_tipeisi : $comm_tipeisi"
  echo "comm_isi     : $comm_isi"

  # comm_user        : @gojibuntu
  # comm_tipe        : !satu
  # comm_tipeisi     : !satu dua tiga empat lima enam tujuh lapan sembilan 
  # comm_isi         : dua tiga empat lima enam tujuh lapan sembilan


  # ==================================================================================================================
  #  filter commands
  # ==================================================================================================================

  if [[ "$comm_tipe" == "!say" || "$comm_tipe" == "!bilang" ]]; then
    do_say
  fi

  if [[ "$comm_tipe" == "!follow" ]]; then
    do_follow
  fi
  
  if [[ "$comm_tipe" == "!unfollow" || "$comm_tipe" == "!leave" ]]; then
    do_unfollow
  fi

  if [[ "$comm_tipe" == "!status" ]]; then
    do_status
  fi


  # quick fix, ntar dibenahin lagi
  if [[ "$comm_tipeisi" != *"!say"* && "$comm_tipeisi" != *"!bilang"* && "$comm_tipeisi" != *"!follow"* && "$comm_tipeisi" != *"!unfollow"* && "$comm_tipeisi" != *"!leave"* && "$comm_tipeisi" != *"!status"* ]]; then
    respon="1"
  fi

}


# ====================================================================================================================
#  command functions
# ====================================================================================================================

do_say() {
  if [[ "$isngadimin" == "1" ]]; then
    echo "[twit] : $comm_user nyuruh kita bilang $comm_isi"
    twit -s "$comm_isi"
  else
    # echo "[twit] : $comm_user nyuruh2 !say"
    twit -r "$twit_id" -s "oi oi.. $comm_user emangnya elu siapa nyruh2 gue gitu..??"
    udahdibalas="1"
  fi
}

do_follow() {
  if [[ "$isngadimin" == "1" ]]; then

    array_who=( $comm_isi )
    for user in "${array_who[@]}"; do
      if [[ "$user" == @* ]]; then
        target=$(echo "$user" | sed 's/[^a-zA-Z0-9@_]//g')
        # echo "$comm_user nyruh kita follow $target"
        twit -f "$target"
      fi
    done
    twit -r "$twit_id" -s "oke bos $comm_user, sudah ane follow barusan :)"

  else
    # echo "[twit] : $comm_user nyuruh2 !follow"
    twit -r "$twit_id" -s "oi oi.. $comm_user emangnya elu siapa nyruh2 gue follow.. elu aja gak follow gue gitu..! "
    udahdibalas="1"
  fi
}

do_unfollow() {
  if [[ "$isngadimin" == "1" ]]; then
    
    array_who=( $comm_isi )
    for user in "${array_who[@]}"; do
      if [[ "$user" == @* ]]; then
        target=$(echo "$user" | sed 's/[^a-zA-Z0-9@_]//g')
        # echo "$comm_user nyruh kita unfollow $target"
        twit -l "$target"
      fi
    done
    twit -r "$twit_id" -s "oke bos $comm_user, sudah ane unfollow barusan, kalau perlu ane blok tuh :)"

  else
    # echo "[twit] : $comm_user nyuruh2 !unfollow"
    twit -r "$twit_id" -s "oi oi.. $comm_user emangnya elu siapa nyruh2 gue gitu..??"
    udahdibalas="1"
  fi
}

do_status() {
  echo "[twit] : $comm_user nanyain status kita"

  statusnya_array=(
      "bokek akut"
      "bokek"
      "kena kanker (kantong kering)"
      "di-PHP-in"
      "galau kamu php in terus"
      "digantung"
      "galau akut"
      "galau"
      "jomblo 3 bulan"
      "jomblo abadi"
      "jomblo akut"
      "jomblo"
      "menggalau"
      "merana karena jomblo"
      "ngejomblo"
      "susah BAB akhir2 ini"
      "susah boker"
      "mencret"
    )
  statusnya_num=${#statusnya_array[*]}
  statusnya=${statusnya_array[$((RANDOM%statusnya_num))]}

  twit -r "$twit_id" -s "hai $comm_user, status aku tuh saat ini lagi $statusnya kayak majikan aku si @gojigeje ..T_T"
  respon="0"
}
