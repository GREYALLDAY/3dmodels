/*[Main]*/
part="test_channel";//[test_channel:test channel,test_joiner:test joiner,cap:cap,mount:mount,info:info,channel:channel,joiner_mid:joiner mid,joiner_end:joiner end,joiner_corner:corner,joiner_spur:spur]
//asembly tolerance
channel_tol=0.2;//[0:0.05:1]
//extrusion width
ew=0.4;//[0:0.01:1.5]

/*[Strip Properties]*/
//half of max width of strips to be used.
max_half_strip_w=6;//[1.5:0.1:12.5]
//thickness of strip including the parts on its surface and add little more for slack.
strip_t=3.4;//[1:0.1:10]
//width of strip
strip_w=12;//[3:0.1:25]
//thickness of just the pcb of the strip (excludes the parts on top). make larger than pcb thickness if theres unused double stick on back.
pcb_t=0.8;//[0.2:0.2:2]
//number of leds per meter. usually 144, 60, or 30
leds_per_m=144;//[20:1:250]

/*[Design Dimensions]*/
//LEDs per channel. should be some multiple of LEDs in your strip.
leds_per_seg=36;//[2:1:250]
//shortens one end of channel and joiner by some leds. effects: channel, joiner mid, joiner end
short=0;//[0:1:25]
//size for locking pin holes
pin_hole=2.2;//[1:0.01:3]
//estimate of joiner thickness. larger is stronger but heavier.
outer_sleve_t=2;//[1:0.2:6]

/*[Mount]*/
//Thickness
bracket_t=2;//[1:0.1:3]
//Width
bracket_w=20;//[10:1:50]
//Diameter of screw head
screw_head_d=6.5;//[1:0.1:15]
//Depth of countersink
screw_head_h=1.5;//[0.5:0.1:5]
//Screw hole diameter
screw_hole_d=3;//[1:0.1:5]
//clipping strength
mount_clip=1;//[0.4:0.1:1.6]
//pan/countersink
screw_head_shp=0;//[0:countersink,1:pan]

/*[Corners and Spurs]*/
//angle for corner
corner_angle=90;//[0:180]
//spur max sides
spur_sides_max=4;//[3:1:8]
//consecutive spur sides used
spur_sides=3;//[3:1:8]

/*[Wiring]*/
//diameter of power wires
power_d=2;//[1:0.2:5.6]
//diameter of signal wire
sig_d=2;//[0.4:0.2:3]
//wire spacing
wire_space=3;//[1:0.1:5]

/*[Diffusion Properties]*/
//diffusion distance
dist=3;//[1:0.2:15]
//diffusion thickness
diff_t=0.8;//[0.6:0.2:2]
//gap between top of baffle and diffuser to let a little out. smooths the look
baffle_bleed=1;//[0:0.2:15.2]

/*[Hidden]*/
//controlls how many sides the arcs of corners etc. have
a_step=360/36;
//some calculations...
//keeps LEDs aligned
channel_gap=channel_tol;
//makes top bridging easier
top_expand=ew*4;
//thickness of baffles. should be 4x extrusion width
baffle_t=4*ew;
//thickness of the bottom of the channel
bottom=pin_hole/1.5+0.2;
//in case you goofed. should be an integer result

//LED spacing
mm_per_led=1000/leds_per_m;
//length of channel
seg_len=leds_per_seg*mm_per_led;

joiner_ow=2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand+(outer_sleve_t)*3;

channel_w=2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand;

joinner_iw=channel_w+channel_tol;

joiner_oh=bottom+strip_t+dist+diff_t+(outer_sleve_t)*1.5;
//length to cut pin hole in joiners
joiner_pin_l=joiner_ow+2;
//length to cut pin hole in channels. actually more like a notch.
channel_pin_l=2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand+2;
//because of multiple wires at a certain spacing. make equal to strip_w in case strip hangs out.
wire_hole_l=strip_w;
//length for test
leds_per_test=5;
test_len=mm_per_led*leds_per_test;
//pin holes space
pin_hole_space=20;
//maximum shorten
max_short=floor(leds_per_seg/2-pin_hole_space*3/mm_per_led);
short_final=min(short,max_short);
//parts:


if(part=="info")info();
if(part=="channel")translate([0,-seg_len/2,0])channel();
if(part=="test_channel")translate([0,-test_len/2,0])test_channel();
if(part=="test_joiner")translate([0,-test_len/2,0])translate([0,test_len/2,outer_sleve_t+channel_tol+pcb_t/2+power_d-pin_hole/2])test_joiner();
if(part=="cap")translate([0,0,outer_sleve_t+channel_tol+pcb_t/2+power_d])cap_w_hole();
if(part=="joiner_mid")translate([0,0,outer_sleve_t+channel_tol+pcb_t/2+power_d])joiner_mid();
if(part=="joiner_end")translate([0,-seg_len/4-mm_per_led,outer_sleve_t+channel_tol+pcb_t/2+power_d])joiner_end();
if(part=="joiner_corner")translate([mm_per_led/2-joiner_ow/2,mm_per_led/2-joiner_ow/2,outer_sleve_t+channel_tol+pcb_t/2+power_d-pin_hole/2])joiner_corner();
if(part=="joiner_spur")translate([0,0,outer_sleve_t+channel_tol+pcb_t/2+power_d-pin_hole/2])joiner_spur();
if(part=="mount")mount();

module mount_hole(l)
{
    /*hull()
    {
        translate([-(joiner_ow+channel_tol)/2,-l/2,-channel_tol])cube([joiner_ow+channel_tol,l,outer_sleve_t+bottom+channel_tol*5+power_d]);
        translate([-(joiner_ow+channel_tol)/6,-l/2,-channel_tol/2])cube([(joiner_ow+channel_tol)/3,l,(outer_sleve_t+bottom+channel_tol*5+power_d)+(joiner_ow+channel_tol)/3]);
    }*/
    union()
    {
        translate([0,-l/2,joiner_oh/2-channel_tol/2+(strip_t+dist)/2])rotate([-90,0,0])channel_hole(l,0,channel_tol+outer_sleve_t);
        translate([-joiner_ow/2-channel_tol*1.5,-l/2,joiner_oh/2-channel_tol*2-outer_sleve_t-channel_tol-pcb_t/2-power_d])cube([joiner_ow+channel_tol*3,l,power_d+1]);
    }
}
module mount()
{
    difference()
    {
        minkowski()
        {
            union()
            {
                mount_hole(bracket_w-bracket_t*2);
                translate([-(channel_tol*3+joiner_ow)/2,-(bracket_w-bracket_t*2)/2,-channel_tol-bracket_t/2])cube([channel_tol*3+joiner_ow,bracket_w-bracket_t*2,outer_sleve_t+channel_tol*2]);
            }
            sphere(r=bracket_t,$fn=6);           
        }
        mount_hole(bracket_w*2);
        translate([-(joiner_ow+bracket_t*2+channel_tol*4)/2,-(bracket_w+2)/2,(outer_sleve_t+bottom+channel_tol*5+power_d)+mount_clip])cube([joiner_ow+bracket_t*2+channel_tol*4,bracket_w+2,joiner_oh]);
            //screw hole
        translate([0,0,bracket_t/2])rotate([180,0,0]){
            cylinder(d1=screw_head_d,d2=screw_head_shp?screw_head_d:screw_hole_d,h=screw_head_h,$fn=30);
            cylinder(d=screw_hole_d,h=2.5*bracket_t,$fn=30);
        }
            //slots
            translate([joiner_ow/3,0,bracket_t/2])rotate([0,45,0])cube([(channel_tol+2*bracket_t-1)*sqrt(2),bracket_w+2,(channel_tol+2*bracket_t-1)*sqrt(2)],center=true);
            translate([-joiner_ow/3,0,bracket_t/2])rotate([0,45,0])cube([(channel_tol+2*bracket_t-1)*sqrt(2),bracket_w+2,(channel_tol+2*bracket_t-1)*sqrt(2)],center=true);
    }
}

module info()
{
    linear_extrude(1)text(str("Total width ",joiner_ow,"mm"));
    translate([0,-10,0])text(str("Normal segment length ",seg_len,"mm"));
    translate([0,-20,0])linear_extrude(1)text(str("Shortened by ",short_final," LEDs (",(short_final*mm_per_led),"mm)"));
    translate([0,-30,0])text(str("Shortened (actual) segment length ",(seg_len-short_final*mm_per_led),"mm"));
}

module test_joiner()
{
    difference()
    {
        union()
        {
            translate([0,channel_gap/2-test_len/2,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])difference()
            {
                channel_hole(test_len-channel_gap,0,outer_sleve_t);
                translate([0,0,-1])channel_hole(test_len+2-channel_gap,outer_sleve_t,channel_tol);        
            }
             //for wire holes   
            translate([-joiner_ow/2,-test_len/2+channel_gap/2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,test_len-channel_gap,power_d+1]);
        }
        //pin holes
        //ends
        translate([0,test_len/2-pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,-test_len/2+pin_hole_space/2,0])pin_hole(joiner_pin_l);
        //wire holes
        translate([0,0,-outer_sleve_t-channel_tol*2-pcb_t-power_d+pin_hole/2])all_wire_holes(l=test_len-channel_gap+2);
        //tap holes
        translate([0,test_len/2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
        translate([0,-test_len/2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
    }
}

module test_channel()
{
    difference()
    {
        //base
        hull()
        {
            translate([-max_half_strip_w/2-top_expand,channel_gap/2,0])cube([max_half_strip_w+2*top_expand,test_len-channel_gap,bottom+strip_t+dist+diff_t]);
            translate([-strip_t-dist-diff_t-max_half_strip_w/2-top_expand,channel_tol/2,0])cube([2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand,test_len-channel_gap,bottom]);        
        }
        //cut out
        p=[[-strip_w/2-channel_tol,0],[-strip_w/2-channel_tol,pcb_t],[-max_half_strip_w/2,(strip_w+2*channel_tol-max_half_strip_w)/2+pcb_t],[-max_half_strip_w/2,strip_t+dist],
        [max_half_strip_w/2,strip_t+dist],[max_half_strip_w/2,(strip_w+2*channel_tol-max_half_strip_w)/2+pcb_t],[strip_w/2+channel_tol,pcb_t],[strip_w/2+channel_tol,0]];
        difference()
        {
            translate([0,-1,bottom])rotate([90,0,180])linear_extrude(test_len+2)polygon(points=p);
            //baffles
            for(i=[0:leds_per_test])translate([0,mm_per_led*i,dist/2+bottom+strip_t+diff_t])cube([max_half_strip_w+2,baffle_t,dist],center=true);
        }
        //botom cut
        translate([-(strip_w-2)/2,baffle_t/2,-1])cube([strip_w-2,test_len-baffle_t,bottom+2]);
        //baffle bleed
        translate([-max_half_strip_w/2,-1,bottom+strip_t+dist-baffle_bleed])cube([max_half_strip_w,test_len+2,baffle_bleed]);
        //pin holes
        translate([0,pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,test_len-pin_hole_space/2,0])pin_hole(joiner_pin_l);
    }
}
module channel()
{
    difference()
    {
        //base
        hull()
        {
            translate([-max_half_strip_w/2-top_expand,channel_gap/2,0])cube([max_half_strip_w+2*top_expand,seg_len-short_final*mm_per_led-channel_gap,bottom+strip_t+dist+diff_t]);
            translate([-strip_t-dist-diff_t-max_half_strip_w/2-top_expand,channel_tol/2,0])cube([2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand,seg_len-short_final*mm_per_led-channel_gap,bottom]);        
        }
        //cut out
        p=[[-strip_w/2-channel_tol,0],[-strip_w/2-channel_tol,pcb_t],[-max_half_strip_w/2,(strip_w+2*channel_tol-max_half_strip_w)/2+pcb_t],[-max_half_strip_w/2,strip_t+dist],
        [max_half_strip_w/2,strip_t+dist],[max_half_strip_w/2,(strip_w+2*channel_tol-max_half_strip_w)/2+pcb_t],[strip_w/2+channel_tol,pcb_t],[strip_w/2+channel_tol,0]];
        difference()
        {
            translate([0,-1,bottom])rotate([90,0,180])linear_extrude(seg_len-short_final*mm_per_led+2)polygon(points=p);
            //baffles
            for(i=[0:leds_per_seg-short_final])translate([0,mm_per_led*i,dist/2+bottom+strip_t+diff_t])cube([max_half_strip_w+2,baffle_t,dist],center=true);
        }
        //botom cut
        translate([-(strip_w-2)/2,baffle_t/2,-1])cube([strip_w-2,seg_len-short_final*mm_per_led-baffle_t,bottom+2]);
        //baffle bleed
        translate([-max_half_strip_w/2,-1,bottom+strip_t+dist-baffle_bleed])cube([max_half_strip_w,seg_len-short_final*mm_per_led+2,baffle_bleed]);
        //pin holes
        //ends
        translate([0,pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,pin_hole_space*1.5,0])pin_hole(joiner_pin_l);
        translate([0,seg_len-short_final*mm_per_led-pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,seg_len-short_final*mm_per_led-pin_hole_space*1.5,0])pin_hole(joiner_pin_l);
        //mid
        translate([0,seg_len/2+pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,seg_len/2-pin_hole_space/2,0])pin_hole(joiner_pin_l);
    }
}

module joiner_mid()
{
    difference()
    {
        union()
        {
            translate([0,channel_gap/2-seg_len/2,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])difference()
            {
                channel_hole(seg_len-channel_gap-short_final*mm_per_led,0,outer_sleve_t);
                translate([0,0,-1])channel_hole(seg_len-short_final*mm_per_led+2-channel_gap,outer_sleve_t,channel_tol);        
            }
             //for wire holes   
            translate([-joiner_ow/2,-seg_len/2+channel_gap/2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,seg_len-channel_gap-short_final*mm_per_led,power_d+1]);
        }
        //pin holes
        //mid
        translate([0,pin_hole_space/2,0])pin_hole(joiner_pin_l);
        translate([0,-pin_hole_space/2,0])pin_hole(joiner_pin_l);
        //ends
        translate([0,seg_len/2-pin_hole_space/2-short_final*mm_per_led,0])pin_hole(joiner_pin_l);
        translate([0,-seg_len/2+pin_hole_space/2,0])pin_hole(joiner_pin_l);
        //wire holes
        translate([0,0,-outer_sleve_t-channel_tol*2-pcb_t/2-power_d+pin_hole/2])all_wire_holes(l=seg_len-channel_gap-short_final*mm_per_led+2);
        //tap holes
        translate([0,seg_len/2-short_final*mm_per_led,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
        translate([0,-seg_len/2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
    }
}
module joiner_end()
{
    difference()
    {
        union()
        {
            translate([0,channel_gap/2+pin_hole_space,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])difference()
            {
                channel_hole(seg_len/2-short_final*mm_per_led-pin_hole_space-channel_gap,0,outer_sleve_t);
                translate([0,0,-1])channel_hole(seg_len/2-short_final*mm_per_led-pin_hole_space-channel_gap+2,outer_sleve_t,channel_tol);    
            }
            //for wire holes
            translate([-joiner_ow/2,channel_gap/2+pin_hole_space,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,seg_len/2-pin_hole_space-channel_gap-short_final*mm_per_led,power_d+1]);
        }
        //pin holes
        //ends
        translate([0,pin_hole_space*1.5,0])pin_hole(joiner_pin_l);
        translate([0,seg_len/2-pin_hole_space/2-short_final*mm_per_led,0])pin_hole(joiner_pin_l);
        //wire holes
        translate([0,0,-outer_sleve_t-channel_tol*2-pcb_t/2-power_d+pin_hole/2])all_wire_holes(l=seg_len-channel_gap+2);
        //tap holes
        translate([0,seg_len/2-short_final*mm_per_led,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
        translate([0,pin_hole_space,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
  }
}
module cap_w_hole()
{
    difference()
    {
        union()
        {
            cap();
            translate([-joiner_ow/2,-pin_hole_space/2-2,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,pin_hole_space-channel_gap/2+2,power_d+1]);
        }
        translate([0,-1,-bottom/2-power_d/2])cube([wire_space*2+power_d,4+pin_hole_space,bottom+outer_sleve_t+power_d+1+dist+bottom+strip_t],center=true);
        //pin hole
        pin_hole(joiner_pin_l);
    }
}
//an adjustable corner
module joiner_corner(a=corner_angle)
{
    union()
    {
        difference()
        {
            corner_arc_out(a);
            corner_arc_in(a);
        }
        translate([joiner_ow/2,0,0])corner_joiner_piece();
        rotate([0,0,a])mirror([0,1,0])translate([joiner_ow/2,0,0])corner_joiner_piece();
    }
}
module joiner_spur()
{
    sa=360/spur_sides_max;
    r=joiner_ow/(2*tan(180/spur_sides_max));
    spur_sides2=min(spur_sides,spur_sides_max);
    difference()
    {
       for(i=[0:1:spur_sides2-2+((spur_sides_max==spur_sides2)?1:0)])rotate([0,0,360/spur_sides_max*i])
            translate([r,joiner_ow/2,0])
        rotate([0,0,90])mirror([1,0,0])corner_arc_out(180-sa);
       for(i=[0:1:spur_sides2-2+((spur_sides_max==spur_sides2)?1:0)])rotate([0,0,360/spur_sides_max*i])
            translate([r,joiner_ow/2,0])
        rotate([0,0,90])mirror([1,0,0])corner_arc_in(180-sa);
    }
    for(i=[0:1:spur_sides2-1])rotate([0,0,360/spur_sides_max*i])
            translate([r,0,0])rotate([0,0,90])corner_joiner_piece();
}

//helpers
//translate([0,0,4.4])test_channel();
//joiner hole/joiner exterior
module channel_hole(l,notch,tol)
{
    translate([0,(bottom+strip_t+pcb_t+dist+tol)/2,0])rotate([90,0,0])union()
    {
        hull()
        {
            translate([-max_half_strip_w/2-top_expand-tol/2,0,top_expand/4])cube([max_half_strip_w+2*top_expand+tol,l,bottom+strip_t+dist+diff_t+tol*1.5]);
            translate([-strip_t-dist-diff_t-max_half_strip_w/2-top_expand-tol*1.5,0,0])cube([2*(strip_t+dist+diff_t)+max_half_strip_w+2*top_expand+tol*3,l,bottom+pcb_t/2+tol/2]);        
        }
        if(notch*1.5>tol)translate([0,0,-tol])hull()
        {
            translate([-(max_half_strip_w+top_expand*2+tol),0,bottom+strip_t+dist+tol+diff_t/2+top_expand/2+0.01+(((max_half_strip_w+2*top_expand+tol)*2)-(max_half_strip_w+2*top_expand+tol))/2])cube([(max_half_strip_w+2*top_expand+tol)*2,l,0.01]);
        translate([-max_half_strip_w/2-top_expand-tol/2,0,bottom+strip_t+dist+tol*3+top_expand/2])cube([max_half_strip_w+2*top_expand+tol,l,0.01]);
        }
    }
}
//plain cap
module cap()
{
    difference()
    {
        translate([0,-pin_hole_space/2-2,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])difference()
        {
            channel_hole(pin_hole_space+2-channel_gap/2,0,outer_sleve_t);
            translate([0,0,2])channel_hole(pin_hole_space+2-channel_gap,outer_sleve_t,channel_tol);    
        }
    }
}
//arcs for corners
module corner_arc_in(a)
{
    for(i=[0:a_step:a])rotate([0,0,i])union()
    {
        hull()
        {
            translate([joiner_ow/2,-1.05,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])channel_hole(2.1,0,channel_tol/3);
            rotate([0,0,a_step])translate([joiner_ow/2,-1.05,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])channel_hole(2.1,0,channel_tol/3);
        }
        hull()
        {
            translate([joiner_ow/2,0,-(strip_t+dist)/2+pin_hole/2])cube([joinner_iw,2.1,strip_t+dist+pin_hole-channel_tol],center=true);
            rotate([0,0,a_step])translate([joiner_ow/2,0,-(strip_t+dist)/2+pin_hole/2])cube([joinner_iw,2.1,strip_t+dist+pin_hole-channel_tol],center=true);
        }
    }
}

module corner_arc_out(a)
{
    difference()
    {
        for(i=[0:a_step:a])rotate([0,0,i])union()
        {
            hull()
            {
                translate([joiner_ow/2,-0.05,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])channel_hole(0.1,0,outer_sleve_t);
                rotate([0,0,a_step])translate([joiner_ow/2,-0.05,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])channel_hole(0.1,0,outer_sleve_t);
            }
            hull()
            {
                translate([0,-0.05,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,0.1,power_d+1]);
                rotate([0,0,a_step])translate([0,-0.05,-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,0.1,power_d+1]);
            }
        }
        mirror([0,1,0])translate([-1,0,-(strip_t+dist)/2-power_d+pin_hole/2])cube([joiner_ow+2,sin(a_step)*joiner_ow,joiner_oh+power_d+2]);
        rotate([0,0,a])translate([-1,0,-(strip_t+dist)/2-power_d+pin_hole/2])cube([joiner_ow+2,sin(a_step)*joiner_ow,joiner_oh+power_d+2]);
    }
}

//leg of corners
module corner_joiner_piece()
{
    difference()
        {
            union()
            {
            translate([0,channel_gap/2-pin_hole_space,(strip_t+dist)/2+pin_hole/2])rotate([-90,0,0])difference()
            {
                channel_hole(pin_hole_space-channel_gap/2+0.1,0,outer_sleve_t);
                translate([0,0,-1])channel_hole(pin_hole_space+2-channel_gap/2+0.1,outer_sleve_t,channel_tol);    
            }
            //for wire holes
            translate([-joiner_ow/2,-(pin_hole_space-channel_gap/2),-outer_sleve_t-channel_tol-pcb_t/2-power_d+pin_hole/2])cube([joiner_ow,pin_hole_space-channel_gap/2,power_d+1]);
        }
            //pin holes
            //ends
            translate([0,-pin_hole_space/2,0])pin_hole(joiner_pin_l);
            //translate([0,-mm_per_led*(leds_per_seg/2-1),0])pin_hole(joiner_pin_l);
            //wire holes
            translate([0,0,-outer_sleve_t-channel_tol*2-pcb_t/2-power_d+pin_hole/2])all_wire_holes(l=seg_len-channel_gap+2);
        //tap hole
        translate([0,0,-power_d-outer_sleve_t-1+pin_hole/2])hull()
        {
            cube([wire_space*2+power_d+channel_tol,wire_space*2+power_d+channel_tol,power_d*2+outer_sleve_t*2+2],center=true);
            translate([0,0,-0.5])cube([wire_space*2+power_d+channel_tol,(wire_space*2+power_d+channel_tol)*2,1],center=true);
        }
        }
}
//holes for pins
module pin_hole(l,d=pin_hole)
{
    rotate([45,0,0])translate([-l/2,0,0])cube([l,d/2,d/2]);
    rotate([0,90,0])cylinder(d=d,h=l,$fn=32,center=true);
}
module all_wire_holes(l)
{
    translate([0,0,sig_d/2])wire_hole(l,d=sig_d);
    translate([-wire_space,0,power_d/2])wire_hole(l,power_d);
    translate([wire_space,0,power_d/2])wire_hole(l,power_d);
}
//holes for wires
module wire_hole(l,d)
{
    rotate([0,-45,0])translate([0,-l/2,0])cube([(d+channel_tol)/2,l,(d+channel_tol)/2]);
    rotate([90,0,0])cylinder(d=(d+channel_tol),h=l,$fn=32,center=true);
    translate([0,0,-(d+channel_tol)/2])cube([(d+channel_tol)*0.97,l,(d+channel_tol)],center=true);
}