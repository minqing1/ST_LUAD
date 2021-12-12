my %result;
my %result_x;
my %result_y;

##Input Format:
#Sample	Tumor	x_coordinate	y_coordinate	panck	cd68	icsbp	cd163	cd206
#Sample	Tumor	x	y	Pos	Pos	Neg	Pos	Pos


open IN, "mIHC_cell_positive.txt";
while ($line=<IN>){
	chomp $line;
	
	my @tmp=split(/\t/,$line);
	my $sample=$tmp[0];
	my $class=$tmp[1];
	my $x=$tmp[2];
	my $y=$tmp[3];
	
	my $tt="$x:$y";
	##$panck_p\t$cd68_p\t$icsbp_p\t$cd163_p\t$cd206_p\n";
	my $panck=$tmp[4];
	my $cd68=$tmp[5];
	my $icsbp=$tmp[6];
	my $cd163=$tmp[7];
	my $cd206=$tmp[8];
	
	my $tt2="$panck:$cd68:$icsbp:$cd163:$cd206";
	
	if ($class=~/Tumor/ && $line =~/Pos/){
		$result{$sample}{$tt}=$tt2;
		
		my $tt_x="$sample:$x";
		my $tt_y="$sample:$y";
		$result_x{$tt_x}=$y;
		$result_y{$tt_y}=$x;
		
	}
	
}
close IN;


foreach my $sample(sort{$a cmp $b}  keys %result){
	foreach my $tt(sort{$a cmp $b}  keys %{$result{$sample}}){
		
		my @tmp1=split(/:/,$tt);
		my $x=$tmp1[0];
		my $y=$tmp1[1];
		
		my @tmp2=split(/:/,$result{$sample}{$tt});
		my $panck=$tmp2[0];
		my $cd68=$tmp2[1];
		my $icsbp=$tmp2[2];
		my $cd163=$tmp2[3];
		my $cd206=$tmp2[4];
		
		my $x_new1=$x-30;
		my $x_new2=$x+30;
		my $y_new1=$y;
		my $y_new2=$y+30;
		
		##取(x,y)下平面的位点
		# 'd_CD68_P',
		# 'd_CD206.CD68_PP',
		# 'd_CD163.CD68_PP',
		# 'd_CD68.ICSBP_PP'
		# 'd_CD163.CD206.CD68_PNP',
		# 'd_CD163.CD206.CD68_PPP',
		# 'd_CD163.CD206.CD68_NPP',
		
		for(my $xx=$x_new1;$xx<=$x_new2;$xx+=0.1){
			my $tt_x="$sample:$xx";
			if(exists $result_x{$tt_x}){
				my $yy=$result_x{$tt_x};
				
				next if ($xx == $x && $yy == $y);
				next if ($yy <= $y_new1);
				next if ($yy >  $y_new2);
				my $tt_new="$xx:$yy";
				if (exists $result{$sample}{$tt_new}){
					my @tmp2_new=split(/:/,$result{$sample}{$tt_new});
					my $panck_new=$tmp2_new[0];
					my $cd68_new =$tmp2_new[1];
					my $icsbp_new=$tmp2_new[2];
					my $cd163_new=$tmp2_new[3];
					my $cd206_new=$tmp2_new[4];
					
					if ($panck eq 'Pos' && $panck_new ne 'Pos'){
						if ($cd68_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_P\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $icsbp_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_ICSBP_PP\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $cd163_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_CD163_PP\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $cd206_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_CD206_PP\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $cd163_new eq 'Pos' && $cd206_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_CD163_CD206_PPP\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $cd163_new eq 'Pos' && $cd206_new eq 'Neg'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_CD163_CD206_PPN\t$dd\n";
						}
						if ($cd68_new eq 'Pos' && $cd163_new eq 'Neg' && $cd206_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$x\t$y\t$xx\t$yy\tPANCK_P\tCD68_CD163_CD206_PNP\t$dd\n";
						}
						
						
					}
					
					if ($cd68 eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_P\t$dd\n";
						}
					}
					
					if ($cd68 eq 'Pos' && $icsbp eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_ICSBP_PP\t$dd\n";
						}
					}
					
					if ($cd68 eq 'Pos' && $cd163 eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_CD163_PP\t$dd\n";
						}
					}
					
					if ($cd68 eq 'Pos' && $cd206 eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_CD206_PP\t$dd\n";
						}
					}
					if ($cd68 eq 'Pos' && $cd163 eq 'Pos' && $cd206 eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_CD163_CD206_PPP\t$dd\n";
						}
					}
					if ($cd68 eq 'Pos' && $cd163 eq 'Pos' && $cd206 eq 'Neg' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_CD163_CD206_PPN\t$dd\n";
						}
					}
					if ($cd68 eq 'Pos' && $cd163 eq 'Neg' && $cd206 eq 'Pos' && $panck ne 'Pos'){
						if ($panck_new eq 'Pos'){
							my $dd_tmp=($x-$xx) ** 2 + ($y-$yy) ** 2;
							my $dd=sprintf("%.3f",sqrt($dd_tmp));
							print "$sample\t$xx\t$yy\t$x\t$y\tPANCK_P\tCD68_CD163_CD206_PNP\t$dd\n";
						}
					}
				
				
				
			   }
		   }
		
	    }
	}		
}	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		




