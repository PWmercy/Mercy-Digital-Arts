FasdUAS 1.101.10   ��   ��    k             l     ��  ��    [ U Similar to script for Terminal, but different syntax for "typing" a command in iTerm     � 	 	 �   S i m i l a r   t o   s c r i p t   f o r   T e r m i n a l ,   b u t   d i f f e r e n t   s y n t a x   f o r   " t y p i n g "   a   c o m m a n d   i n   i T e r m   
  
 l     ��  ��    + % Created by P White (pwhite@mercy.edu     �   J   C r e a t e d   b y   P   W h i t e   ( p w h i t e @ m e r c y . e d u      l     ��  ��      v. 20161028     �      v .   2 0 1 6 1 0 2 8      l     ��  ��    = 7 Place within Remote Desktop application scripts folder     �   n   P l a c e   w i t h i n   R e m o t e   D e s k t o p   a p p l i c a t i o n   s c r i p t s   f o l d e r      l     ��  ��    u o Takes the current selection of computers in Remote Desktop and opens an ssh session in a tab iniTerm for each.     �   �   T a k e s   t h e   c u r r e n t   s e l e c t i o n   o f   c o m p u t e r s   i n   R e m o t e   D e s k t o p   a n d   o p e n s   a n   s s h   s e s s i o n   i n   a   t a b   i n i T e r m   f o r   e a c h .      l     ��   !��     R L Differentiates between servers (based on a list of IPs) and regular clients    ! � " " �   D i f f e r e n t i a t e s   b e t w e e n   s e r v e r s   ( b a s e d   o n   a   l i s t   o f   I P s )   a n d   r e g u l a r   c l i e n t s   # $ # l     ��������  ��  ��   $  % & % l     '���� ' r      ( ) ( J     ����   ) o      ���� 0 thepinglist thePingList��  ��   &  * + * l     ��������  ��  ��   +  , - , l     ��������  ��  ��   -  . / . l   7 0���� 0 O    7 1 2 1 Q   	 6 3 4�� 3 k    - 5 5  6 7 6 r     8 9 8 l    :���� : 1    ��
�� 
sele��  ��   9 o      ���� 0 thecomputers theComputers 7  ;�� ; X    - <�� = < r   " ( > ? > n   " % @ A @ 1   # %��
�� 
IPAD A o   " #���� 0 x   ? l      B���� B n       C D C  ;   & ' D o   % &���� 0 thepinglist thePingList��  ��  �� 0 x   = o    ���� 0 thecomputers theComputers��   4 R      ������
�� .ascrerr ****      � ****��  ��  ��   2 m     E E�                                                                                  mcp   alis    B  Macintosh HD               �!HCBD ����Remote Desktop.app                                             �����O        ����  
 cu             Applications  "/:Applications:Remote Desktop.app/  &  R e m o t e   D e s k t o p . a p p    M a c i n t o s h   H D  Applications/Remote Desktop.app   / ��  ��  ��   /  F G F l     ��������  ��  ��   G  H I H l     �� J K��   J   Create sessions.    K � L L "   C r e a t e   s e s s i o n s . I  M N M l  8 � O���� O O   8 � P Q P k   < � R R  S T S l  < <��������  ��  ��   T  U V U I  < A������
�� .Itrmnwwnnull��� ��� null��  ��   V  W X W l  B B��������  ��  ��   X  Y Z Y l  B B�� [ \��   [   Create tab.    \ � ] ]    C r e a t e   t a b . Z  ^ _ ^ X   B ~ `�� a ` k   R y b b  c d c l  R R��������  ��  ��   d  e f e O   R ^ g h g I  X ]������
�� .Itrmntwnnull���     obj ��  ��   h 1   R U��
�� 
Crwn f  i j i l  _ _��������  ��  ��   j  k l k l  _ _�� m n��   m / ) Establish connections & execute actions.    n � o o R   E s t a b l i s h   c o n n e c t i o n s   &   e x e c u t e   a c t i o n s . l  p q p l  _ _��������  ��  ��   q  r s r O   _ w t u t I  i v���� v
�� .Itrmsntxnull���     obj ��   v �� w��
�� 
Text w l  m r x���� x b   m r y z y m   m p { { � | |  p i n g   - i 5   z o   p q���� 0 x  ��  ��  ��   u n   _ f } ~ } 1   d f��
�� 
Wcsn ~ n   _ d  �  1   b d��
�� 
Crtb � 1   _ b��
�� 
Crwn s  ��� � l  x x��������  ��  ��  ��  �� 0 x   a o   E F���� 0 thepinglist thePingList _  ��� � l   ��������  ��  ��  ��   Q m   8 9 � ��                                                                                  ITRM  alis    0  Macintosh HD               �!HCBD ����	iTerm.app                                                      �����R        ����  
 cu             	Utilities   #/:Applications:Utilities:iTerm.app/    	 i T e r m . a p p    M a c i n t o s h   H D   Applications/Utilities/iTerm.app  / ��  ��  ��   N  ��� � l     ��������  ��  ��  ��       �� � � � �����   � ��������
�� .aevtoappnull  �   � ****�� 0 thepinglist thePingList�� 0 thecomputers theComputers��   � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �  % � �  . � �  M����  ��  ��   � ���� 0 x   � �� E���������������� ������������� {���� 0 thepinglist thePingList
�� 
sele�� 0 thecomputers theComputers
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
IPAD��  ��  
�� .Itrmnwwnnull��� ��� null
�� 
Crwn
�� .Itrmntwnnull���     obj 
�� 
Crtb
�� 
Wcsn
�� 
Text
�� .Itrmsntxnull���     obj �� �jvE�O� / &*�,E�O �[��l kh  ��,�6F[OY��W X  	hUO� F*j O ;�[��l kh  *�, *j UO*�,�,�, *a a �%l UOP[OY��OPU � �� ���  �   �����������������~�}�|�{�z�y�x � � � �  1 7 2 . 3 1 . 4 8 . 9 4��  ��  ��  ��  ��  ��  ��  �  �~  �}  �|  �{  �z  �y  �x   � �w ��w  �   � �  � �  E�v ��u
�v 
gstl � � � � H F 7 3 5 3 1 3 C - 6 3 D 2 - 4 F 3 C - B 1 3 F - B B 7 9 4 2 0 A 0 6 2 E
�u kfrmID  ��  ascr  ��ޭ