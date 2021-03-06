			opt s-
			move.w #0,track
			pea cls				;display header
			move.w #9,-(sp)
			trap #1
			addq.l #6,sp
			move.w #7,-(sp)			;wait key
			trap #1
			addq.l #2,sp
			pea go				;display start
			move.w #9,-(sp)
			trap #1
			addq.l #6,sp
			lea $68000,a6			;setup track table
			clr.l (a6)+
			move.w #0,-(sp)
			pea outfile			;create lump file
			move.w #$3c,-(sp)
			trap #1
			addq.l #8,sp
			move.w d0,d7
read			move.w #0,-(sp)			;open track file
			pea file
			move.w #$3d,-(sp)
			trap #1
			addq.l #8,sp
			move.w d0,d6
			pea $60000			;read track file
			pea $ffff
			move.w d6,-(sp)
			move.w #$3f,-(sp)
			trap #1
			add.l #12,sp
			btst #0,d0			;make file even !!
			beq even
			addq.l #1,d0
even			move.l d0,d1
			add.l -4(a6),d1			;next entry in table
			move.l d1,(a6)+
			pea $60000			;write file to lump
			move.l d0,-(sp)
			move.w d7,-(sp)
			move.w #$40,-(sp)
			trap #1
			add.l #12,sp
			move.w d6,-(sp)			;close track file
			move.w #$3e,-(sp)
			trap #1
			addq.l #4,sp
			pea prin			;display filename
			move.w #9,-(sp)
			trap #1
			addq.l #6,sp
			move.b (file+3),d0
			sub.b #'0',d0
			add.b d0,(file+11)		;next filename
			eor.b #1,(file+3)
			cmp.b #":",(file+11)
			bne ok
			move.b #"0",(file+11)
			addq.b #1,(file+10)
ok			addq.w #1,track
			cmp.w #160,track		;last file ?
			bne read

read2			move.w #0,-(sp)			;open track file
			pea file2
			move.w #$3d,-(sp)
			trap #1
			addq.l #8,sp
			move.w d0,d6
			pea $60000			;read track file
			pea $ffff
			move.w d6,-(sp)
			move.w #$3f,-(sp)
			trap #1
			add.l #12,sp
			btst #0,d0			;make file even !!
			beq even2
			addq.l #1,d0
even2			move.l d0,d1
			add.l -4(a6),d1			;next entry in table
			move.l d1,(a6)+
			pea $60000			;write file to lump
			move.l d0,-(sp)
			move.w d7,-(sp)
			move.w #$40,-(sp)
			trap #1
			add.l #12,sp
			move.w d6,-(sp)			;close track file
			move.w #$3e,-(sp)
			trap #1
			addq.l #4,sp
			pea prin2			;display filename
			move.w #9,-(sp)
			trap #1
			addq.l #6,sp
			addq.b #1,(file2+9)		;next filename
			cmp.b #":",(file2+9)
			bne ok2
			move.b #"0",(file2+9)
			addq.b #1,(file2+8)
ok2			addq.w #1,track2
			cmp.w #80,track2			;last file ?
			bne read2

			move.w d7,-(sp)			;close lump file
			move.w #$3e,-(sp)
			trap #1
			addq.l #4,sp
			pea tabfile			;create table file
			move.w #$3c,-(sp)
			trap #1
			addq.l #8,sp
			move.w d0,d7
			pea $68000			;write table file
			move.l #$3c0,-(sp)
			move.w d7,-(sp)
			move.w #$40,-(sp)
			trap #1
			add.l #12,sp
			move.w d7,-(sp)			;close table file
			move.w #$3e,-(sp)
			trap #1
			addq.l #4,sp
			pea end				;display end
			move.w #9,-(sp)
			trap #1
			addq.l #6,sp
			move.w #7,-(sp)			;wait key
			trap #1
			addq.l #2,sp
			clr.w -(sp)			;exit
			trap #1
track2			dc.w 0
prin2			dc.b 10,13
file2			dc.b "g:\2\trk00",0,0
track			dc.w 0
prin			dc.b 10,13
file			dc.b "g:\0\track00",0,0
outfile			dc.b "g:\lump",0,0
tabfile			dc.b "g:\table",0
cls			dc.b 27,'E',27,'f'
			dc.b "Zip-Load V1.00",10,13
			dc.b "Filed Track to Lump Converter.",10,10,13
			dc.b "Insert File Disk in Drive A",10,13
			dc.b "Insert Lump disk in Drive B",10,10,13
			dc.b "Press any key to begin conversion...",10,10,13,0
go			dc.b "Conversion in Progress....",10,13,0
end			dc.b 10,10,13
			dc.b "File Conversion Complete !!!",0
			