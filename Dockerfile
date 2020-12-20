FROM ubuntu:20.04

# References:
#  - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1400-vitis-embedded.pdf
#  - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug973-vivado-release-notes-install-license.pdf

ARG DISPLAY
ENV DISPLAY=$DISPLAY

ARG XILINX_USERNAME
ENV XILINX_USERNAME=$XILINX_USERNAME

ARG XILINX_PASSWORD
ENV XILINX_PASSWORD=$XILINX_PASSWORD

RUN apt-get update && apt-get install -y \
    curl \
    expect \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY genAuthToken.exp /
COPY install_config.txt /

RUN curl --fail --output "/Xilinx_Unified_2020.2_1118_1232_Lin64.bin" "https://xilinx-ax-dl.entitlenow.com/dl/ul/2020/11/19/R210407432/Xilinx_Unified_2020.2_1118_1232_Lin64.bin/b9311aafea00f3547c75243f1b5a59d9/5FDF260E?akdm=0&filename=Xilinx_Unified_2020.2_1118_1232_Lin64.bin" \
 && chmod a+x /Xilinx_Unified_2020.2_1118_1232_Lin64.bin \
 && /Xilinx_Unified_2020.2_1118_1232_Lin64.bin --noexec --nox11 --target /tmp/installer \
 && rm /Xilinx_Unified_2020.2_1118_1232_Lin64.bin \
 && chmod a+x genAuthToken.exp \
 && /genAuthToken.exp \
 && /tmp/installer/xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --config /install_config.txt --batch INSTALL --xdebug
