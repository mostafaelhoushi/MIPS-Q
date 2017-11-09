#
# This is a non-pipelined version of the multiplication 
# routine. I.e. branch slots do not exist!
#
#     
     .data
     .align        
dbuf:.space 64*4   
    
     .text
			ori		$1,	$0,	578
			ori		$2,	$0,	345    				
			jal		mult				
			
end:	j			end			
			
mult:
			ori		$9, $0, 15
			move	$10,$0
m_Loop:
			andi	$3, $2, 1
			srl		$2,	$2,	1
			beq		$3, $0, m_NoAdd1
			
			addu	$10,$10,$1
m_NoAdd1:
			sll		$1,	$1,	1			
			addiu	$9,	$9,	-1
			bne		$9, $0,  m_Loop   		
			
			move	$9,	$10
			jr		$31
			
			
			
			