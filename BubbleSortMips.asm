.data
.text 				
		
.globl main                    
main:                          
		li $s2, 0 					# $s2 input sentinel value
		
start:	                        	
		li $v0, 5 					# Get value for the first node
		syscall                 	
		move $a0, $v0 # val     	
		jal create_node        		# Create the first node
		move $s0, $v0          		# Points to the first node
		move $s1, $v0 #last    		# Points to last node
		
input_loop:                     	
		li $v0, 5 					
		syscall                 	
		move $s3, $v0 				
									
		beq $s3, $s2, end_input		# if the sentinel then break
									
		move $a0, $s3 				# Argument
		jal create_node 			# Create the node
									
		sw $v0, 4($s1)  			# Insert to the list
		move $s1, $v0           	
		b input_loop 	       		# repeat input loop.
					
end_input:                      	
									
		jal BubbleSort          	
									
		jal print               	
									
		b start             
    	
create_node:                    	
		subu $sp, $sp, 24       	
		sw $ra, 20($sp)         	
		sw $fp, 16($sp)         	
		sw $s2, 4($sp)          	
		addu $fp, $sp, 24       	
									
		move $a1, $a0 				# The value to create for
									
		li $a0, 8					# Allocate  bytes for the new node.
		li $v0, 9 					
		syscall                 	
		move $s2, $v0           	
									
		sw $a1, 0($s2) 				# node->number = number
		sw $zero, 4($s2) 			# node->next = null
									
		move $v0, $s2 				
									
									
		lw $ra, 20($sp) 			
		lw $fp, 16($sp) 			
		lw $s2, 4($sp) 				
		addu $sp, $sp, 24 			
		jr $ra 						
## end of create_node.          	
									
									
BubbleSort:                     	
		addi $sp, $sp, -32     		
		sw $ra, 28($sp) 				
		sw $a3, 24($sp) 				
		sw $a2, 20($sp) 			
		sw $a1, 16($sp)		    	
		sw $a0, 12($sp)	    
    	
		move $a3, $s1        		# Get first node address
		beq $s0, $s1, endSort   	# Check empty
		   	
outter:                         	
		move $a0, $s0           	# Points to the first
		lw $a1, 4($s0)          	# Points to next
		add $a2, $zero, $zero   	# Switch status
									
inner:	                        	# Load values
		lw $t0, 0($a0)          	
		lw $t1, 0($a1)          	
									# Compare values
		beq $t0, $t1, endInner  	
		bgt $t0, $t1,swap       	
									
									
endInner:		                	
		beq $a1, $a3, endOutter		# node == last ? go outter : go inner

		move $a0, $a1				# node = node.next
		lw $t2, 4($a1)
		move $a1, $t2	
		j inner
		
endOutter:
		move $a3, $a0				# last = last - 1
		bne $a2, $zero, outter		# finish sort ? end sort : go outter
		j endSort

swap:
		lw $t0, 0($a0)				# swap nodes valuse
		lw $t1, 0($a1)
		sw $t1, 0($a0)
		sw $t0, 0($a1)
		addi $a2, $zero, 1		

		lw $t0, 4($a1)				#swap pointers
		move $a0, $a1
		move $a1, $t0
		bne $a0, $a3, inner			# node == last ? go outter : go inner

		j endOutter	
		
endSort:
		sw $ra, 28($sp) 			
		sw $a3, 24($sp) 			
		sw $a2, 20($sp) 			
		sw $a1, 16($sp)		
		sw $a0, 12($sp)	

		add $sp, $sp, 32
		jr $ra
		
print:
		subu $sp, $sp, 32
		sw $ra, 28($sp)
		sw $fp, 24($sp)
		sw $s0, 20($sp)
		sw $a0, 16($sp)
		sw $a1, 12($sp)
		
		addu $fp, $sp, 32	
		move $a1, $s0 				# get start
		
next:		
		lw $t0, 4($a1)				# loop in the list
		beqz $t0, print_end 
		
		lw $a0, 0($a1) 		
		li $v0, 1
		syscall
		la $a0, newline 	
		li $v0, 4
		syscall

		move $a1, $t0
		b next

print_end: 				
		lw $a0, 0($a1) 				# print last
		li $v0, 1
		syscall
		la $a0, newline 	
		li $v0, 4
		syscall
		
		lw $ra, 28($sp) 	
		lw $fp, 24($sp) 	
		lw $s0, 20($sp) 	
		lw $a0, 16($sp)
		lw $a1, 12($sp)
		
		addu $sp, $sp, 32 
		jr $ra 				


		.data
newline: 		.asciiz "\n"
