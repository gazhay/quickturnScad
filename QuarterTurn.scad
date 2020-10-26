$fn=60;

// Male
module outerLip(dia=20, depth=1.2, tag=2, deg=45){
    module wedge(){
        hull(){
            rotate([0,0,-deg/2])
            color("pink")
            translate([0,-0.5,-1])
            cube([dia+tag,1,3]);

            rotate([0,0,deg/2])
            color("pink")
            translate([0,-0.5,-1])
            cube([dia+tag,1,3]);
        }
    }
    //color("grey")
    intersection(){
        color("green")
        union(){
            rotate([0,0,180])
            wedge();
            wedge();
        }
        color("red")
        cylinder(d=dia+tag, depth);
    }
    cylinder(d=dia, depth);
}
module wedgeCuts( depth=2, width=10, start=2, end=1, attack=10 ){
    module flange(){
        rotate([0,attack,0])
        translate([start,-0.5,depth])
        cube([width-start-end,1,depth]);
    }
    module oneWedge(){
        hull(){
            rotate([0,0,width/2])
            flange();
            rotate([0,0,-width/2])
            flange();
        }
    }
    rotate([0,0,180])
    oneWedge();
    oneWedge();
}
module boobCut( depth=3, width=10, start=3, outerdepth=1.2){
    module boob(){
        color("purple")
        resize([width,width*2,depth])
        sphere(d=1);
    }
    translate([0,width+start,depth/2+(depth-outerdepth)/2])
    boob();
    translate([0,-width-start,depth/2+(depth-outerdepth)/2])
    boob();
}
module underneath(dia=20, depth=2){
    translate([0,0,-depth])
    cylinder(d=dia, depth);
}
module male(){
    color("teal")
    difference(){
        outerLip(dia=25, depth=1.75, tag=3, deg=40);
        wedgeCuts(width=14, end=2.5);
        boobCut(outerdepth=1.2);
    }
    underneath(dia=25, depth=3);
    translate([0,0,-3])
    underneath(dia=27, depth=2);
}

// Female
module cutoot(cutat=4.5, size=3, space=4){
    module oneCut(){
        hull(){
            translate([0, space, 0])
            color("pink")
            cylinder(d=3, 3);
            translate([0, space+100, 0])
            color("pink")
            cylinder(d=3, 3);
        }
    }
    translate([ cutat,0,-0.5]) oneCut();
    translate([-cutat,0,-0.5]) oneCut();
    rotate([0,0,180])
    union(){
        translate([ cutat,0,-0.5]) oneCut();
        translate([-cutat,0,-0.5]) oneCut();
    }
}
module base(dia=23.5, thickness=2, connector=9, outer=33.5){
    color("cyan")
    difference(){
        union(){
            cylinder(d=dia, thickness);

            intersection(){
                translate([-(outer+10)/2,-(connector/2),-0.5])
                cube([outer+10,connector,thickness+1]);

                color("pink")
                cylinder(d=outer, thickness);
            }
        }
        cutoot();
    }
}
module countersunkHole( screwDia=4, headDia=6.5, thickness=2){
    translate([0,0,-1])
    cylinder(d=screwDia, thickness+2);
    translate([0,0,thickness/2])
    cylinder(d1=screwDia, d2=headDia, thickness/2);
}
module counterAt( at=10.7 ){
    translate([-at,0,0]) countersunkHole();
    translate([ at,0,0]) countersunkHole();
}
module outerRing(size=33.5, ringsize=2, height=6, overhang=5, overhangsize=2, connector=9){
    difference(){
        union(){
            translate([0,0,height-overhangsize])
            difference(){
                cylinder(d=size, overhangsize);
                translate([0,0,-1])
                cylinder(d=size-overhang-ringsize, overhangsize+2);
            }
            difference(){
                cylinder(d=size, height);
                translate([0,0,-1])
                cylinder(d=size-ringsize,height+2);
            }
        }

        translate([0,0,height-2])
        intersection(){
            cylinder(d=size-2, overhangsize+2);
            color("red")
            cube([size,connector,overhang+2], center=true);

        }
    }
}
module female( basedepth=2){
    module flange(attack=10, start=5.75, end=3.3, width=15, depth=basedepth-0.2){
        rotate([0,-attack,0])
        translate([start,-0.5,-depth/2])
        cube([width-start-end,1,depth]);
    }
    module hulledFlange(angle=5){
        difference(){
            hull(){
                rotate([0,0,angle/2])
                flange(depth=(basedepth/3*2)-0.5);
                rotate([0,0,-angle/2])
                flange(depth=(basedepth/3)  -0.5 );
                flange();
            }
            translate([0,0,-2])
            cylinder(d=25, 2);
        }
    }
    difference(){
        union(){
            difference(){
                base(thickness=basedepth);
                counterAt();
            }
            rotate([0,0,90])
            union(){
                rotate([0,0,180])
                hulledFlange(5);
                hulledFlange(5);
            }
            outerRing(connector=12);
            lockWedges();
        }
        thinBase();
    }
}
color("orange")
female();

/* color("pink")
translate([0,0,4])
rotate([0,180,90])
male(); */
/*
rotate([0,180,90])
outerLip(dia=25, depth=1.75, tag=3, deg=40); */
module lockWedges(){

    translate([0,0,5])
    union(){
        rotate([0,180,0])
        lockWedge();
        rotate([0,180,180])
        lockWedge();
    }
}
module lockWedge(){
    intersection(){
        difference(){
            intersection(){

                translate([-15,6,0])
                color("salmon")
                cube([10,10,10]);

                rotate([0,0,-44])
                color("green")
                cube([100,10,10], center=true);
            }

            color("yellow")
            translate([0,0,-0.1]);
            cylinder(d=26.5, 10);

        }

        color("yellow")
        translate([0,0,-0.1])
        cylinder(d=33.5, 10);

    }
}

module thinBase(){
    module thinWedge(depth=1, angle=8){
        color("cyan")
        rotate([angle,0,0])
        translate([0,9,-depth*1.15])
        cube([9,10,depth], center=true);
    }

    rotate([0,0,180])
    thinWedge();
    thinWedge();
}
