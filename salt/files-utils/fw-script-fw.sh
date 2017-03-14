#!/bin/sh
#
#--------------Firewall da BesideYou---------------
#--Totalmente modular, não deve ser modificado por pessoal não autorizado--
#--Firewall Tipo 1, isto eh, protege 1 (um) link externo.
#--Deverah existir um tipo 2 (dois links) externos
#
##

##----------Definindo as variaveis---------------
#--Todo o tipo de informação deve ficar sempre em variavel, nunca diretamente
#--dentro do codigo, como por exemplo o IP de alguma estação. Deve-se criar
#--uma variavel como:  PCRH="191.168.1.12" PCDIR="192.168.1.$WEB"
#  

#Boot via service iptables  arquivo em /etc/sysconfig/iptables

#==========DEFININDO DEVICES===================
#-- Trocas de ETH devem ser feitas aqui, nunca diretamente no codigo!
#-- tambem poderah  ser:  ppp0 ppp1 ppp2 eth0:1 eth2:1 eth2:2 ou outros
#-- Sempre respeite as tags "em uso" e "sem uso" colcando a variavel abaixo
#-- da tag correta quando ela passar a ser utilizada ou deixar de ser.
#em uso
PLACA0="enp0s3"; #00:22:15:D5:82:0C 
PLACA1="enp0s8"; #00:40:F4:92:8E:7B

#sem uso
PLACA2="eth2";
PLACA3="eth3";
PLACA4="eth4";
PLACA5="eth5";

#--Previstos ateh 3 links no mesmo firewall, o normal é um ou no maximo 2
#em uso
IEXT_0=$PLACA0;
#sem uso
IEXT_1=$PLACA3;
IEXT_2=$PLACA2;

#--Previstas ateh 3 redes internas.
#--Por vivencia aprendi que se confunde IEXT_0 com RINT-0, por isso adotei letras ABC
#em uso
RINT_A=$PLACA1;
#sem uso
RINT_B=$PLACA2;
RINT_C=$PLACA5;
#========FIM===DEFINDINDO DEVICES======================

MYSTATE="NEW,INVALID,UNTRACKED"
MYLIMIT=" -m limit --limit 6/minute --limit-burst 6"
#==============DEFININDO VARIAVEIS GERAIS===================

ANY="0.0.0.0/0"
#deverah ser incluida uma validacao do local, carregando sempre de onde estiver
#e avisando se não localizar.
IPTABLES=$(which iptables)

#====PORTAS====
#--JAMAIS, JAMAIS digite uma porta diretamente no codigo, SEMPRE, SEMPRE crie a variável.
#--Algo claro e esplicativo de preferencias, mas KISS, lembre-se Keep It Simple Stupid.
UP_PORTS="1024:"
D_PORTS=":1024"
VNCC="5900";
VNCWEB="5800";
MSTSC="3389";
SSH="22";
SSH_1="27500";
SSH_2="38001";
SSH_3="38002";
WEBMIN="10000";
FEDSRV="9090"
DNS="53";
WEB="80";
WEB2="8080";
SQUID="3128";
MINION="4505:4506";
WEBSSL="443";
CAIXA4="2631";
CAIXA6="3456";
SYNC="873" # rsync
CUPS="631" # cups

SMTP="25";
POP="110";
GMAIL="465"    # bradesco e gmail
GMAIL2="995"    # bradesco e gmail
SMTPX="109" # SMTP
POPSSL="995" # pop ssl
SMTP2="587" # smtp2
IMAP2="143" # imap2
IMAP="993" # imap




#========FIM======DEFININDO VARIAVEIS GERAIS===================


#=======DEFINDO IPS================
#--Não serão definidos os (3) IPs externos, trabalharemos somente com as interfaces por hora.
#--Aqui serão definidas até 3 IPs internos, para até 3 redes internas, caso precise de mais
#--crie variaveis no mesmo padrão.
#
IPCX1="200.201.160.0/24";
IPCX2="200.201.174.0/24";
IPCX3="200.201.166.0/24";
IPCX4="200.201.173.0/24";
IPethNET="10.0.2.2";

#em uso
REXTERNA_0="10.0.2.0/24"

RINTERNA_0="192.168.2.0/24"


#sem uso
RINTERNA_1="0.0.0.0/24"
RINTERNA_2="0.0.0.0/24"

#--Enderecos remotos para tratamentos especiais a determinados IPs
# ENDREMOTO para acesso via SSH ou MTSC
#em uso
ENDREMOTO="177.194.42.150"
#sem uso
ENDREMOTO2="200.175.79.156"

#--Servidor de MST em uma das redes internas
#--Aqui vc seta o IP interno desse servidor para que o firewall repasse as conexões para ele.
SERV_TSC1="0.0.0.0"

#--Listagem de IPs de estações

PCTESTE="192.168.2.104";

#===FIM====DEFINDO IPS================

stop() {
	inic
	echo -e "Firewall parado, todas as regras limpas"
					
}

inic() {
##### Limpa as regras anteriores #####
        $IPTABLES -F
        $IPTABLES -F INPUT
        $IPTABLES -F FORWARD
        $IPTABLES -F OUTPUT
	$IPTABLES -F -t mangle
	$IPTABLES -Z -t mangle
        $IPTABLES -F -t nat
        $IPTABLES -Z -t nat
        $IPTABLES -X
        $IPTABLES -Z
        $IPTABLES -P INPUT ACCEPT
        $IPTABLES -P OUTPUT ACCEPT
        $IPTABLES -P FORWARD ACCEPT
}

teste () {
	inic

	#$IPTABLES -t nat -A POSTROUTING -s $RINTERNA_0 -o $IEXT_0 -p tcp --dport $DNS -j LOG --log-prefix "TESTE--$PCTESTE--> "
	#$IPTABLES -t nat -A POSTROUTING -s $RINTERNA_0 -o $IEXT_0 -p tcp --dport $WEB -j LOG --log-prefix "TESTE--$PCTESTE--> "

	$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -j MASQUERADE
}


sohnat () {
	inic
	$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -j MASQUERADE
}

natsquid () {
	inic
	#ativando mascaramento
	$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -j MASQUERADE

	#RINT_A  = PLACA1 = ETH1 RINTERNA_0=RESTRICAO IPS REDE LOCAL
	$IPTABLES -t nat -A PREROUTING -p tcp -s $RINTERNA_0 -i $RINT_A --dport $WEB -j REDIRECT --to-port $SQUID
	$IPTABLES -t nat -A PREROUTING -p udp -s $RINTERNA_0 -i $RINT_A --dport $WEB -j REDIRECT --to-port $SQUID

}

start () {
	inic

#=========================================
#--Carregando os modulos do $IPTABLES:
/sbin/modprobe ip_tables
/sbin/modprobe ip_conntrack
/sbin/modprobe iptable_nat
/sbin/modprobe ip_nat_ftp


#============ATIVANDO RECURSOS ESPECIAIS====================
# 
#============PROT. CONTRA IP Spoofing=======================
     for i in /proc/sys/net/ipv4/conf/*/rp_filter; do
      echo 1 >$i
     done
     
#==============ATIVANDO RED. PACTS. P/NAT====================
     echo "1" >/proc/sys/net/ipv4/ip_forward
#     echo "4096" > /proc/sys/net/ipv4/ip_conntrack_max


#==========DEFINICAO DE POLITICAS=============
#
#===============TABELA FILTER=================
#$IPTABLES -t filter -P INPUT DROP
$IPTABLES -t filter -P INPUT ACCEPT
$IPTABLES -t filter -P OUTPUT ACCEPT
#$IPTABLES -t filter -P FORWARD DROP
$IPTABLES -t filter -P FORWARD ACCEPT
#===============TABELA NAT====================
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT

#=====FIM=====DEFINICAO DE POLITICAS=============

#========CONEXOES ESTABELECIDAS
$IPTABLES -I INPUT  1 -m state --state RELATED,ESTABLISHED -j ACCEPT
$IPTABLES -I OUTPUT 1 -m state --state RELATED,ESTABLISHED -j ACCEPT
 
#===============INPUT======================== 
#--Aceita todo o trafego vindo do loopback e indo pro loopback
$IPTABLES -A INPUT  -i lo -j ACCEPT

#===============OUTPUT======================== 

$IPTABLES -A OUTPUT -i lo -j ACCEPT
#ALLOS OUT DCHP CLIENT TO CONECT
$IPTABLES -A OUTPUT -o $EXT_0 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
# DNS QUEREY
$IPTABLES -A OUTPUT -o $EXT_0 -p udp -m udp --dport 53 -j ACCEPT
# E-MAIL OUT
$IPTABLES -A OUTPUT -o $EXT_0 -p tcp -m tcp --dport $SMTP -m state --state NEW  -j ACCEPT
# PING
$IPTABLES -A OUTPUT -o $EXT_0 -p icmp -j ACCEPT
# NTP REQUEST
$IPTABLES -A OUTPUT -o $EXT_0 -p udp --dport 123 --sport 123 -j ACCEPT
#OUT HTTP FOR WORKSTATIONS
$IPTABLES -A OUTPUT -o $EXT_0 -p tcp -m tcp  --dport $WEB -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -o $EXT_0 -p tcp -m tcp  --dport $WEBSSL -m state --state NEW -j ACCEPT

#--Todo trafego vindo da rede interna tambem aceito
$IPTABLES -A INPUT -i $RINT_A -j ACCEPT


#$IPTABLES -A INPUT -s $RINTERNA_1 -i $RINT_B -j ACCEPT
#--Liberacao de PING (ICMP) na Interface Externa com certa limitacao
#$IPTABLES -A INPUT -i $IEXT_0 -p icmp -m limit --limit 2/s -j ACCEPT
#
#$IPTABLES -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT



#===============INPUT======================== 
#=======TRATAMENTO DAS PORTAS===========
#--Liberacao de Portas de Servico 
#em uso
$IPTABLES -A INPUT -i $RINT_A -s $RINTERNA_0 -p tcp --dport $SSH_1 -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPTABLES -A OUTPUT -o $RINT_A               -p tcp --sport $SSH_1 -m state --state ESTABLISHED -j ACCEPT
$IPTABLES -A INPUT -i $RINT_A -s $RINTERNA_0 -p tcp --dport $SSH   -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPTABLES -A OUTPUT -o $RINT_A               -p tcp --sport $SSH   -m state --state ESTABLISHED -j ACCEPT

$IPTABLES -A INPUT -i $RINT_A -s $RINTERNA_0 -p tcp --dport $WEBMIN -m state --state NEW,ESTABLISHED -j ACCEPT
#$IPTABLES -A OUTPUT -o $RINT_A               -p tcp --sport $WEBMIN -m state --state ESTABLISHED -j ACCEPT

$IPTABLES -A INPUT -i $IEXT_0 -s $REXTERNA_0 -p tcp --dport $MINION -j ACCEPT
$IPTABLES -A OUTPUT -o $IEXT_0 -s $REXTERNA_0 -p tcp --dport $MINION -j ACCEPT
$IPTABLES -A INPUT -i $RINT_A -s $RINTERNA_0 -p tcp --dport $MINION -j ACCEPT
$IPTABLES -A OUTPUT -o $RINT_A -s $RINTERNA_0 -p tcp --dport $MINION -j ACCEPT


$IPTABLES -A INPUT -i $IEXT_0 -s $REXTERNA_0 -p tcp --dport $FEDSRV -j ACCEPT
$IPTABLES -A INPUT -i $RINT_A -s $RINTERNA_0 -p tcp --dport $FEDSRV -j ACCEPT


#sem uso
#$IPTABLES -A INPUT -i $IEXT_0 -s $ENDREMOTO -p tcp --dport $SSH_1 -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s $ENDREMOTO -p tcp --dport $SSH -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport $SMTP -j ACCEPT
$IPTABLES -A INPUT -i $RINT_A -s 0/0 -p tcp --dport $DNS -j ACCEPT
$IPTABLES -A INPUT -i $RINT_A -s 0/0 -p udp --dport $DNS -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport $WEB -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport $MSTSC -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport $VNCC -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport $VNCWEB -j ACCEPT
$IPTABLES -A INPUT -p tcp -m tcp -syn -m multiport --dport $WEB,$WEBSSL -m connlimit --connlimit-above 20 -j REJECT --reject-with-tcp-reset

#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport 5500 -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s 0/0 -p tcp --dport 5560 -j ACCEPT

#=======MICROSOFT TERMINAL SERVICE CLIENT=====================
#--Porta $MSTSC (TS)
#$IPTABLES -A INPUT -i $IEXT_0 -s $ENDREMOTO -p tcp --dport $MSTSC -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -s $ENDREMOTO2 -p tcp --dport $MSTSC -j ACCEPT

#--Redirecionamentos para o servidor TS local 
#$IPTABLES -t nat -A PREROUTING -i $IEXT_0 -s $ENDREMOTO -p tcp --dport $MSTSC -j DNAT --to-destination $SERV_TSC1
#$IPTABLES -t nat -A PREROUTING -i $IEXT_0 -s $ENDREMOTO2 -p tcp --dport $MSTSC -j DNAT --to-destination $SERV_TSC1
#$IPTABLES -A FORWARD -i $IEXT_0 -p tcp -s $ENDREMOTO -d $SERV_TSC1 --dport $MSTSC -j ACCEPT
#$IPTABLES -A FORWARD -i $IEXT_0 -p tcp -s $ENDREMOTO2 -d $SERV_TSC1 --dport $MSTSC -j ACCEPT

#--Liberando as portas altas.
#$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport $UP_PORTS -j ACCEPT
#$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $UP_PORTS -j ACCEPT
#drop high ports
#$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport $UP_PORTS -j DROP
#$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $UP_PORTS -j DROP
#drop low ports
#$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport $D_PORTS -j DROP
#$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $D_PORTS -j DROP

#
#  S/E/G/U/R/A/N/C/A 
#
#
# Protecao contra port scanners ocultos
#$IPTABLES -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
#iptables -I INPUT -s 82.0.0.0/0.0.0.0 -j DROP
#iptables -I INPUT -s 124.0.0.0/0.0.0.0 -j DROP
#===============LOG DE SEGURANCA======================== 
#===============NO SYSLOG======================== 
# A tentativa de acesso externo a estes servicoos serao registrados no syslog
# do sistema e serao bloqueados pelas regras abaixo.

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 23 $MYLIMIT -j LOG --log-level 4 --log-prefix "FIREWALL: telnet"
$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 23 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 110 $MYLIMIT -j LOG --log-level 4 --log-prefix "FIREWALL: pop3 "
$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 110 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 113 $MYLIMIT -j LOG --log-level 4 --log-prefix "FIREWALL: identd "
$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 113 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport 111 $MYLIMIT  -j LOG --log-level 4 --log-prefix "FIREWALL: udp rpc"
$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport 111 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 111  $MYLIMIT -j  LOG --log-level 4 --log-prefix "FIREWALL:  rpc"
$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 111 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 137:139 $MYLIMIT  -j LOG --log-level 4 --log-prefix "FIREWALL: netbios "
$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport 137:139 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport 137:139 $MYLIMIT  -j LOG --log-level 4 --log-prefix "FIREWALL: udp netbios "
$IPTABLES -A INPUT -i $IEXT_0 -p udp --dport 137:139 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $SQUID  $MYLIMIT -j LOG --log-level 4 --log-prefix "FIREWALL: squid externo"

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $SQUID -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $WEB  $MYLIMIT  -j LOG --log-level 4 --log-prefix "FIREWALL: 80 in"

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $WEB   -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $WEB2  $MYLIMIT -j LOG --log-level 4 --log-prefix "FIREWALL: 8080 in"

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $WEB2  -j DROP


$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $SSH_1  $MYLIMIT  -m state --state $MYSTATE -j LOG --log-level 4 --log-prefix "FIREWALL: ssh 27500"
$IPTABLES -A INPUT -i $IEXT_0 -s $REXTERNA_0 -p tcp --dport $SSH_1 -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $SSH   $MYLIMIT   -m state --state $MYSTATE -j LOG --log-level 4 --log-prefix "FIREWALL: ssh 22 std"
$IPTABLES -A INPUT -i $IEXT_0 -s $REXTERNA_0 -p tcp --dport $SSH -j DROP

$IPTABLES -A INPUT -i $IEXT_0 -p tcp --dport $WEBMIN  $MYLIMIT  -m state --state $MYSTATE -j LOG --log-level 4 --log-prefix "FIREWALL: webmin 10000"
$IPTABLES -A INPUT -i $IEXT_0 -s $REXTERNA_0 -p tcp --dport $WEBMIN -j DROP





#######################################################
#                BLOQUEIO E LIBERA. MSN               #
#######################################################
#$IPTABLES -A FORWARD -s $PCAIUR -p tcp --dport 1863 -j ACCEPT
#$IPTABLES -A FORWARD -s $PCAIUR -d loginnet.passport.com -j ACCEPT
#$IPTABLES -A FORWARD -s $PCAIUR -d login.live.com -j ACCEPT
#Adicionado(ed) Bloqueio msn
#$IPTABLES -A FORWARD -s $RINTERNA_0 -p tcp --dport 1863 -j DROP
#$IPTABLES -A FORWARD -s $RINTERNA_0 -d loginnet.passport.com -j DROP
#$IPTABLES -A FORWARD -s $RINTERNA_0 -d login.live.com -j DROP


#######################################################
#                   Tabela nat                        #
#######################################################

##### Chain PREROUTING #####
# Redirecionando Porta $WEB para SQUID (somente para proxy  transparente)

#em uso

# Libera o acesso a clientes de email, pop e smtp
$IPTABLES -A FORWARD -p tcp --dport $SMTP   -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $POP    -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $GMAIL  -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $GMAIL2 -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $SMTPX  -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $POPSSL -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $SMTP2  -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $IMAP2  -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport $IMAP   -j ACCEPT

#Obs: ips não filtrados pelo squid 
#$IPTABLES  -t nat -A PREROUTING -p tcp -S $RINTERNA_0 -i $RINT_A --dport $WEB -j ACCEPT
#$IPTABLES  -t nat -A PREROUTING -p tcp -S $RINTERNA_0 -i $RINT_A --dport $WEBSSL -j ACCEPT

#Obs: BLOQUEAR PORTAS WEB PARA FORÇAR USO PROXY CONFIGURADO

#$IPTABLES -A FORWARD -m state --state NEW,ESTABLISHED -p tcp --dport $WEB -j DROP
#$IPTABLES -A FORWARD -m state --state NEW,ESTABLISHED -p tcp --dport $WEBSSL -j DROP

#$IPTABLES -A FORWARD -m state --state NEW,ESTABLISHED -p tcp --dport $WEB -j ACCEPT
#$IPTABLES -A FORWARD -m state --state NEW,ESTABLISHED -p tcp --dport $WEBSSL -j ACCEPT

#sem uso
#RINT_A  = PLACA1 = enp5s0
#$IPTABLES -t nat -A PREROUTING -p tcp -s $RINTERNA_0 -i $RINT_A --dport $WEB -j REDIRECT --to-port $SQUID
#$IPTABLES -t nat -A PREROUTING -p udp -s $RINTERNA_0 -i $RINT_A --dport $WEB -j REDIRECT --to-port $SQUID



# Exemplo de redirecionamento de portas para HOST na Rede interna
#em uso
########------------ROTEAMENTO PARA SERVIDOR -------------------########
#MAIS SEGURO
#$IPTABLES -A INPUT -i $IEXT_0 -s $ENDREMOTO -p tcp --dport $SSH -j ACCEPT
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $SSH -j DNAT --to-destination $PCTESTE:$SSH
#######-----------------------------------------------------------------------#######

#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $SSH_3 -j DNAT --to $PCAIUR:$SSH_1
#sem uso
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $DNS -j DNAT --to 192.168.0.2:$DNS
#$IPTABLES -t nat -A PREROUTING -p udp -i $IEXT_0 --dport $DNS -j DNAT --to 192.168.0.2:$DNS
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $WEB -j DNAT --to 192.168.0.2:$WEB
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $SSH_2 -j DNAT --to 192.168.1.77:$SSH_2
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $SMTP -j DNAT --to 192.168.1.3:$SMTP
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport 143 -j DNAT --to 192.168.1.3:143
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $25500 -j DNAT --to 192.168.1.2:$SSH
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $VNCC -j DNAT --to 192.168.0.66:$VNCC
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport 5560 -j DNAT --to 192.168.0.6:5560
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport 5500 -j DNAT --to 192.168.0.6:5500
#$IPTABLES -t nat -A PREROUTING -p tcp -i $IEXT_0 --dport $MSTSC -j DNAT --to 192.168.0.5:$MSTSC


#Masquerade LIBERA INTERNET 
$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -j MASQUERADE
#24/01/2009 trocado para atuar somente nas duas redes habilitadas.
####$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -s $RINTERNA_0 -j MASQUERADE
#$IPTABLES -t nat -A POSTROUTING -o $IEXT_0 -s $RINTERNA_1 -j MASQUERADE


# Qualquer outra conexao desconhecida e imediatamente registrada e derrubada
#$IPTABLES -A INPUT -i $IEXT_0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Bloqueia qualquer tentativa de nova conexao de fora para esta maquina
#$IPTABLES -A INPUT -i $IEXT_0 -m state --state NEW,INVALID -j LOG --log-level 4 --log-prefix "FIREWALL: IN BLOCKED"
#$IPTABLES -A INPUT -i $IEXT_0 -m state --state NEW,INVALID -j DROP


#$IPTABLES -A FORWARD -i $IEXT_0 -m state --state NEW,INVALID -j DROP
#$IPTABLES -A FORWARD -s $ANY -d $RINTERNA_0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#$IPTABLES -A FORWARD -s $ANY -d $REXTERNA_0 -m state --state RELATED,ESTABLISHED -j ACCEPT

}
##Todos os comandos deve estar ou na função start ou na stop
case "$1" in
   'start')
	start
	;;
   'stop')
	stop
	;;
   'sohnat')
   	sohnat
	;;
   'natsquid')
   	natsquid
	;;
   'teste')
   	teste
	;;
   *)
	echo "Use $0 start|stop|sohnat|natsquid"
	;;
esac
exit 0	
