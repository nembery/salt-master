#!/bin/bash
# Copyright (c) 2018, Palo Alto Networks
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
This script was derived from: https://amplitude.com/blog/2016/03/03/deploying-docker-saltstack
"""

if [[ $# -lt 2 ]];then
  echo "Please provide a container_name and image_id to compare"
  # return 0 so salt doesn't think the images are different
  exit 0
fi

# return 0 if container not running
if [[ $(/usr/bin/docker ps --filter name=$1 -q |wc -l) -eq 0 ]];then
  exit 0
fi

# return >0 if containers do not match.
/usr/bin/docker inspect --format "{{ .Image }}" $1 \
  |grep $(/usr/bin/docker inspect --format "{{ .Id }}" $2)