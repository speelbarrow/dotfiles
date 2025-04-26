{ ... }: [''
smol() {
  ffmpeg -i $1 -c:v libx265 -tag:v hvc1 -c:a aac -b:a 224k -crf 28 "$(echo "$1" | cut -f 1 -d \
  '.').mp4"
} 
'']
