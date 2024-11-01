#!/usr/bin/env bash

if [ -d "$PWD/resamplescope" ]; then
  echo "Skip cloning, ResampleScope already exists at $PWD/resamplescope"
  cd $PWD/resamplescope
else
  git clone https://github.com/jsummers/resamplescope.git
  cd resamplescope && make
  ./rscope -gen
  ./rscope -gen -r
fi

vips_kernels=(lanczos3 mks2013 mks2021)
for kernel in "${vips_kernels[@]}"; do
  vips reduceh pd.png pd_vips_$kernel.png 1.003603604 --kernel $kernel
  vips reducev pdr.png pdr_vips_$kernel.png 1.003603604 --kernel $kernel
  ./rscope -name "$kernel reduceh" -nologo \
    pd_vips_$kernel.png ../output/pd_vips_$kernel-out.png
  ./rscope -name "$kernel reducev" -nologo -r \
    pdr_vips_$kernel.png ../output/pdr_vips_$kernel-out.png
done
