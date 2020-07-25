//============================
//GUI for quadratic 2-D maps
//Jose Gonzales, July 2016
//Updated functions, April 2020
//=============================

//Main program
//=============

	defaultfont = "arial";				// Default Font

	// Window Parameters initialization
	frame_w = 300; frame_h = 550;		// Frame width and height
	plot_w = 600; plot_h = 550;			// Plot width and heigh
	margin_x = 15; margin_y = 15;		// Horizontal and vertical margin for elements

	axes_w = 3*margin_x + frame_w + plot_w;	// axes width
	axes_h = 2*margin_y + frame_h;		// axes height

	gui_maps2d = scf(100001);			// Create window with id=100001 and make it the current one
	
	// Background and text
	gui_maps2d.background      = -2;
	gui_maps2d.figure_position = [0 0];
	gui_maps2d.figure_name     = "Sistemas Dinámicos Discretos Cuadráticos 2D";
	gui_maps2d.axes_size = [axes_w axes_h];
	
	// ------------------
	// Window menu
	// ------------------
	
	// Remove Scilab graphics menus & toolbar
	delmenu(gui_maps2d.figure_id,gettext("&File"));
	delmenu(gui_maps2d.figure_id,gettext("&Tools"));
	delmenu(gui_maps2d.figure_id,gettext("&Edit"));
	delmenu(gui_maps2d.figure_id,gettext("&?"));
	toolbar(gui_maps2d.figure_id,"off");

	// menu definition - Updated Feb 18, 2020
	h1 = uimenu("parent",gui_maps2d, "label",gettext("Archivo"));
	uimenu("parent",h1, "label","Importar coeficientes", "callback", "Importar_coef();");
	uimenu("parent",h1, "label","Exportar imagen", "callback", "Exportar_imagen();");
	uimenu("parent",h1, "label","Exportar coeficientes", "callback", "Exportar_coef();");
	uimenu("parent",h1, "label","Cerrar", "callback", "gui_maps2d=get_figure_handle(100001);delete(gui_maps2d);", "tag","close_menu");

	h2 = uimenu("parent",gui_maps2d, "label","Herramientas");
	h21 = uimenu("parent",h2,"label", "Retrato fase");
	uimenu("parent",h21, "label","Curvas estacionarias", "callback", "curvas_estac();");
	uimenu("parent",h21, "label","Mostrar puntos fijos", "callback", "Puntos_fijos();");
	uimenu("parent",h21, "label","Graficar órbitas", "callback", "Graficar_orbitas();");
	uimenu("parent",h21, "label","Exponente de Lyapunov", "callback", "exponenteL();");
	uimenu("parent",h21, "label","Curvas críticas", "callback", "curvas_criticas();");
	h22 = uimenu("parent",h2,"label", "Evolución");
	uimenu("parent",h22, "label","Prender/apagar series", "callback", "prender_apagar();");
	h23 = uimenu("parent",h2,"label", "Análisis global", "callback", "analisis_global()");

	h3 = uimenu("parent",gui_maps2d, "label","Ayuda");
	uimenu("parent",h3, "label","Información", "callback","GUI_About();");
	uimenu("parent",h3, "label","Ecuaciones del sistema", "callback","mostrar_ecuaciones();");

	// Sleep to guarantee a better display (avoiding to see a sequential display)
	sleep(500);
   
	// ---------------------
	// Main frame
	// ---------------------

	my_frame = uicontrol("parent",gui_maps2d, "style","frame", ...
		"units","pixels", ...
		"relief","groove", ...
		"position",[margin_x margin_y frame_w frame_h], ...
		"horizontalalignment","center",...
		"background",[1 1 1], ...
		"tag","frame_control");

	my_frame_title = uicontrol("parent",gui_maps2d, "style","text", ...
		"string","Parámetros", ...
		"units","pixels", ...
		"position",[30+margin_x margin_y+frame_h-10 frame_w-60 20], ...
		"fontname",defaultfont,...
		"fontunits","points", ...
		"fontsize",16,...
		"horizontalalignment","center", ...
		"background",[1 1 1],...
		"tag","title_frame_control");

	// -------------------------
	// Populate the frame
	// -------------------------

	guih1 = 540;
	l1 = 40; l3 = 80;

	labels_a = ["$a_1$", "$a_2$", "$a_3$", "$a_4$", "$a_5$", "$a_6$"];
	//         1      x     x2    xy    y     y2
	values = [ 0.0, -1.5,  0.0,  0.0,  1.0,  0.0];
	for k=1:6
		uicontrol("parent",gui_maps2d, "style","text",...
			"string",labels_a(k),...
			"position",[l1, guih1 - k*20, 20, 20], ...
			"horizontalalignment","left",...
			"fontsize",12, ...
			"background",[1 1 1]);
		guientry(k) = uicontrol("parent",gui_maps2d, "style","edit", ...
			"string",string(values(k)),...
			"position",[l3, guih1 - k*20, 40, 20], ...
			"horizontalalignment","left",...
			"tag", labels_a(k),...
			"background",[.9 .9 .9]);
	end

	labels_b = ["$b_1$", "$b_2$", "$b_3$", "$b_4$", "$b_5$", "$b_6$"];
	//         1      x     x2    xy    y     y2
	values = [-2.1,  0.0,  1.0,  0.0,  0.0,  0.0];
	for k=1:6
		uicontrol("parent",gui_maps2d, "style","text",...
			"string",labels_b(k),...
			"position",[140, guih1 - k*20, 20, 20], ...
			"horizontalalignment","left",...
			"fontsize",12, ...
			"background",[1 1 1]);
		guientry(k) = uicontrol("parent",gui_maps2d, "style","edit", ...
			"string",string(values(k)),...
			"position",[180, guih1 - k*20, 40, 20], ...
			"horizontalalignment","left",...
			"tag", labels_b(k),...
			"background",[.9 .9 .9]);
	end

	labels_c = ["$1$", "$x$", "$x^2$", "$xy$", "$y$", "$y^2$"];

	for k=1:6
		uicontrol("parent",gui_maps2d, "style","text",...
			"string",labels_c(k),...
			"position",[240, guih1 - k*20, 20, 20], ...
			"horizontalalignment","left",...
			"fontsize",12, ...
			"background",[1 1 1]);
	end

	//escape radius =================================================
	uicontrol(gui_maps2d, "style","text",...
		"string","Radio de escape al infinito:",...
		"position",[40,390,140,20], ...//[x left bottom, y left bottom, w, h]
		"horizontalalignment","left",...
		"fontsize",10, ...
		"background",[1 1 1]);
	uicontrol(gui_maps2d, "style","edit", ...
		"string","5",...
		"position",[180,390,40,20], ...//[x left bottom, y left bottom, w, h]
		"horizontalalignment","left",...
		"tag", "r_esc",...
		"background",[.9 .9 .9]);

	//select phase portrait color ====================================
	uicontrol(gui_maps2d, "style","text",...
		"string","Región de no-divergencia",...
		"position",[80,360,170,20], ...//[x left bottom, y left bottom, w, h] 
		"horizontalalignment","left",...
		"fontsize",12, ...
		"background",[1 1 1]);

	frame_background = uicontrol(gui_maps2d, "style", "frame", ...
		"backgroundcolor", [1 1 1], ...
		"position",[60,280,170,80], ...//[x left bottom, y left bottom, w, h]
		"border", createBorder("line", "lightGray", 1), ...
		"layout_options", createLayoutOptions("grid",[2,1]),...
		"layout","grid");

	uicontrol(frame_background, "style", "pushbutton",...
		"tag", "button_color_i", ....
		"backgroundcolor", [1 1 0], ...
		"relief", "raised", ...
		"string", "Interior", ...
		"callback", "update_color_i");
	uicontrol(frame_background, "style", "pushbutton",...
		"tag", "button_color_e", ....
		"backgroundcolor", [106/255 90/255 205/255], ...
		"relief", "raised", ...
		"string", "Exterior", ...
		"callback", "update_color_e");

	//slider for grid size ========================================

	function slider_update()
		my_value = string(get(handle_slider,"Value"));
		set(slider_text, "String", "Valor: " + my_value);
	endfunction

	uicontrol(gui_maps2d, "style","text",...
		"string","Tamaño de celda",...
		"position",[l1,200,80,20], ... //[x left bottom, y left bottom, w, h]
		"horizontalalignment","left",...
		"fontsize",10, ...
		"background",[1 1 1]);    

	frame_slider = uicontrol(gui_maps2d, "style", "frame", ...
		"position",[120,200,170,20], ...//[x left bottom, y left bottom, w, h]
		"border", createBorder("line", "lightGray", 1), ...
		"layout", "border");

	slider_text = uicontrol(gui_maps2d, "Style", "text",...
		"Position", [120,180,170,20],...//[x left bottom, y left bottom, w, h]
		"FontSize", 10,...
		"FontWeight", "bold",...
		"BackgroundColor",[1 1 1],...
		"HorizontalAlignment", "center",...
		"Tag", "slider_text_tag");

	handle_slider = uicontrol(frame_slider, "style", "slider", ...
		"backgroundcolor", [.9 .9 .9], ...
		"value", 0.05, ...
		"min", 0.01, ...
		"max", 0.50, ...
		"sliderstep", [0.01, 0.05], ...
		"callback", "slider_update();", ...
		"tag", "gridsize");

	slider_update();
	// end slider grid size =========================================

	function radio_update()

		set(findobj("tag", "evolution_radio"), "value", 0);
		set(findobj("tag", "phase_radio"), "value", 0);
		set(gcbo, "value", 1);

	endfunction

	uicontrol(gui_maps2d, "style", "radiobutton", ...
		"position", [40 120 200 20], ...
		"string", "Evolución del sistema",...
		"horizontalalignment", "left",...
		"value", 0, ...
		"background", [1 1 1], ...
		"callback", "radio_update();",...
		"tag", "evolution_radio");

	uicontrol(gui_maps2d, "style", "radiobutton", ...
		"position", [40 220 200 20], ...
		"string", "Retrato fase del sistema",...
		"horizontalalignment", "left",...
		"value", 1, ...
		"background", [1 1 1], ...
		"callback", "radio_update();",...
		"tag", "phase_radio");

	//slider for number of iterations =======================================

	function slider2_update()
		my_value = string(get(handle_slider2,"Value"));
		set(slider2_text, "String", "Valor: " + my_value);
	endfunction

	uicontrol(gui_maps2d, "style","text",...
		"string","# de iteraciones",...
		"position",[40,100,80,20], ... 
		"horizontalalignment","left",...
		"fontsize",10, ...
		"background",[1 1 1]);    

	frame_slider2 = uicontrol(gui_maps2d, "style", "frame", ...
		"position",[120,100,170,20], ...
		"border", createBorder("line", "lightGray", 1), ...
		"layout", "border");

	slider2_text = uicontrol(gui_maps2d, "Style", "text",...
		"Position", [120,80,170,20],...
		"FontSize", 10,...
		"FontWeight", "bold",...
		"BackgroundColor",[1 1 1],...
		"HorizontalAlignment", "center",...
		"Tag", "slider2_text_tag");

	handle_slider2 = uicontrol(frame_slider2, "style", "slider", ...
		"backgroundcolor", [.9 .9 .9], ...
		"value", 50, ...
		"min", 10, ...
		"max", 1000, ...
		"sliderstep", [10, 100], ...
		"callback", "slider2_update();", ...
		"tag", "niter");

	slider2_update();
	// end slider niter =========================================

	//button mapcompute
	uicontrol(gui_maps2d, "style","pushbutton", ...
		"Position",[110 160 100 20],...//[x left bottom, y left bottom, w, h]
		"String","Ejecutar", ...
		"BackgroundColor",[.9 .9 .9],...
		"fontsize",14, ...
		"relief","raised",...
		"Callback","mapcompute");

	//button evolution
	uicontrol(gui_maps2d, "style","pushbutton", ...
		"Position",[110 60 100 20],...//[x left bottom, y left bottom, w, h]
		"String","Graficar", ...
		"BackgroundColor",[.9 .9 .9],...
		"fontsize",14, ...
		"relief","raised",...
		"Callback","evolution");

// End main program 
//==================

function update_color_i
    [my_red, my_green, my_blue] = uigetcolor();
    if( (my_red<>[]) & (my_green<>[]) & (my_blue<>[]) ) then
        set(gcbo,"BackgroundColor",[ my_red/255 my_green/255 my_blue/255 ]);
    end
endfunction

function update_color_e
    [my_red, my_green, my_blue] = uigetcolor();
    if( (my_red<>[]) & (my_green<>[]) & (my_blue<>[]) ) then
        set(gcbo,"BackgroundColor",[ my_red/255 my_green/255 my_blue/255 ]);
    end
endfunction

function z = pol2(c, x, y)  //c is a vector of lexicographic coefficients
    z = c(1) + x*(c(2) + c(3)*x + c(4)*y) + y*(c(5) + c(6)*y)
endfunction
    
function mapcompute()

    delete(gca());
    drawlater();
    my_plot_axes = gca();
    my_plot_axes.title.font_size = 3;
    my_plot_axes.axes_bounds = [0.3 0 0.7 1]; //[x_left,y_up,width,height]

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

    if (q1(3))^2+(q1(6))^2+(q1(4))^2 == 0 then
        string_caso = "Caso L"
    else
        if (q1(3) * q1(6) - (q1(4)/2)^2 > 0) then
            string_caso = "Caso P";
        else
            if (q1(3) * q1(6) == (q1(4)/2)^2) then
                string_caso = "Caso C";
            else
                string_caso = "Caso H";
            end
        end;
    end;
    
    if (q2(3))^2+(q2(6))^2+(q2(4))^2 == 0 then
        string_caso = string_caso + "L"
    else
        if (q2(3) * q2(6)- (q2(4)/2)^2 > 0) then
            string_caso = string_caso + "P";
        else
            if (q2(3) * q2(6) == (q2(4)/2)^2) then
                string_caso = string_caso + "C";
            else
                string_caso = string_caso + "H";
            end
        end;
    end;
        
    my_plot_axes.title.text = "Retrato fase del sistema - " + string_caso;
    obj = findobj("tag", "button_color_i");
    my_red = obj.backgroundcolor(1)*255;
    my_green = obj.backgroundcolor(2)*255;
    my_blue = obj.backgroundcolor(3)*255;
    color_i = color(my_red,my_green,my_blue);
    obj = findobj("tag", "button_color_e");
    my_red = obj.backgroundcolor(1)*255;
    my_green = obj.backgroundcolor(2)*255;
    my_blue = obj.backgroundcolor(3)*255;
    color_e = color(my_red,my_green,my_blue);
    
    obj = findobj("tag", "r_esc");
    r = evstr(obj.string);
    
    //Algorithm starts here ====================================
    clear x y cells;    
    nmax = 5*r+10;
    xmin = -r;
    xmax = r;
    ymin = -r;
    ymax = r;
    gridsizeobj = findobj("tag", "gridsize");
    gridsize = gridsizeobj.value;
    
    tic();
    
    for i = 1 :(ymax-ymin)/gridsize
        for j = 1: (xmax-xmin)/gridsize
			k = 0;
			x = xmin+(j-1)*gridsize;
			y = ymax-(i-1)*gridsize;
			cond1 = (k < nmax);
			cond2 = (x*x+y*y < r*r);
			while cond1 & cond2
				xp = pol2(q1,x,y); yp = pol2(q2,x,y);
				x = xp;  y = yp;
				k = k+1;
				cond1 = (k < nmax);
				cond2 = (x*x+y*y < r*r);
			end
			if cond1 then
				rcolor = color_e;
			else
				if cond2 then
					rcolor = color_i;
				else
					rcolor = color_e;
				end;
			end;
			cells(i,j)=rcolor
		end
    end

    telapsed = toc();
    
    Matplot1(cells,[xmin,ymin,xmax,ymax]);
    my_plot_axes.isoview = "on";
    my_plot_axes.tight_limits = "on";
    my_plot_axes.data_bounds = [xmin,ymin;xmax,ymax]
    my_plot_axes.axes_visible = ["on" "on" "off"];
    xlabel("$x$","fontsize",4);
    ylabel("$y$","fontsize",4,"rotation",0);
    
    //end algorithm ==================================================
    xinfo("Tiempo transcurrido: " + string(telapsed) + " s");
    drawnow();

endfunction

function Exportar_imagen()

	PathFileName=uiputfile("*.png","C:\Users\jgonzalesborja\Documents\scilab\results\","Guardar imagen");
	xs2png(gcf(),PathFileName);
	xinfo("Imagen exportada.");

endfunction

function Importar_coef()
    
	PathFileName=uigetfile("*.txt","C:\Users\jgonzalesborja\Documents\scilab\results\","Seleccionar archivo");
	fid = mopen(PathFileName,"r");
	my_coef =mfscanf(fid,"%s %s %s %s %s %s")
	for k =1:6
		obj = findobj("tag", labels_a(k));
		obj.string = my_coef(k);
	end
	my_coef =mfscanf(fid,"%s %s %s %s %s %s")
	for k =1:6
		obj = findobj("tag", labels_b(k));
		obj.string = my_coef(k);
	end
	mclose(fid);

	xinfo("Coeficientes importados.");

endfunction

function Exportar_coef()

	for k =1:6
		obj = findobj("tag", labels_a(k));
		q1(k) = obj.string;
	end
	for k =1:6
		obj = findobj("tag", labels_b(k));
		q2(k) = obj.string;
	end
	PathFileName=uiputfile("*.txt","C:\Users\jgonzalesborja\Documents\scilab\results\","Guardar coeficientes");
	fid = mopen(PathFileName,"w");
	mfprintf(fid,"%s %s %s %s %s %s\n", q1(1),q1(2),q1(3),q1(4),q1(5),q1(6));
	mfprintf(fid,"%s %s %s %s %s %s\n", q2(1),q2(2),q2(3),q2(4),q2(5),q2(6));
	mclose(fid);
	xinfo("Coeficientes guardados.");

endfunction

function GUI_About()
	msg = msprintf("(c) 2016-2020.\nAuthor: J. Gonzales \n jose.gonzales.borja@gmail.com");
	messagebox(msg, gettext("Ayuda"), "info", "modal");
endfunction

function mostrar_ecuaciones()

    str_equation_x = "$x_{k+1} = a_1 + a_2x_k + a_3x_k^2 + a_4x_ky_k+ a_5y_k + a_6y_k^2$";
    str_equation_y = "$y_{k+1} = b_1 + b_2x_k + b_3x_k^2 + b_4x_ky_k+ b_5y_k + b_6y_k^2$";

	latexw = figure("figure_name", "Ecuaciones de iteración", ...
	"toolbar_visible", "off", ...
	"infobar_visible", "off", ...
	"backgroundcolor", [1 1 1], ...
	"figure_size", [640 200], ...
	"figure_position", [0 0], ...
	"dockable", "off");

	delmenu(latexw.figure_id,gettext("&File"));
	delmenu(latexw.figure_id,gettext("&Tools"));
	delmenu(latexw.figure_id,gettext("&Edit"));
	delmenu(latexw.figure_id,gettext("&?"));

	frame_equation = uicontrol(latexw, "style", "frame",...
	"position",[40,40,600,80],...//[x left bottom, y left bottom, w, h] 
	"layout_options", createLayoutOptions("grid",[2,1]),...
	"layout","grid");
 
	uicontrol(frame_equation,"style","text",...
	"string", str_equation_y, ...
	"horizontalalignment", "left",...
	"backgroundcolor", [1 1 1], ...
	"fontsize",16);
	uicontrol(frame_equation,"style","text",...
	"string", str_equation_x,...
	"horizontalalignment","left",...
	"backgroundcolor", [1 1 1], ...
	"fontsize",16);

endfunction

function curvas_estac()

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end
    obj = findobj("tag", "r_esc");
    r = evstr(obj.string);
    
	x = linspace(-r,r,20*r);  //size of the curve matches graph size
	y = linspace(-r,r,20*r);
	function z = delta_x(x,y)
		z = pol2(q1,x,y) - x;
	endfunction
	function z = delta_y(x,y)
		z = pol2(q2,x,y) - y;
	endfunction
	xset("fpf", " ");
	contour2d(x,y,delta_x,[0,0],[1,1]);
	contour2d(x,y,delta_y,[0,0],[5,5]);
	xinfo("Curva estacionaria de x en negro, y en rojo");
//	legends(["$\Delta x_k = 0$","$\Delta y_k = 0$"],[1,5],opt=6,with_box=%t);

endfunction

function Puntos_fijos()
//show nature of the fixed point as a line in the message box

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

	function y = pfq2(x)
		y = [pol2(q1,x(1),x(2)) - x(1); pol2(q2,x(1),x(2)) - x(2)]
	endfunction

	xinfo("Haga click cerca a la intersección de las curvas estacionarias...");
	seed = locate(1,1);
	xinfo("");
	[x0, value, info]=fsolve(seed, pfq2);

	plot2d(x0(1), x0(2),-9);
	xstring(x0(1),x0(2),"$F$");
	handletext = get("hdl");
	handletext.font_size = 4;

	format(5);
	msg = "F = (" + string(x0(1)) + ","+ string(x0(2))+ ")";
	select info
		case 1 then
			line2 = "Error < 10^-10"
		case 2 then
			line2 = "Número máximo de iteraciones alcanzado"
		case 3 then
			line2 = "La tolerancia es muy baja"
		case 4 then
			line2 = "Algoritmo no converge"
		else
			line2 = "Parámetros incorrectos"
	end;

	function [v1, v2] = raices(x,y)
		fx = q1(2) + 2*q1(3)*x + q1(4)*y;
		fy =                     q1(4)*x + q1(5) + 2*q1(6)*y;
		gx = q2(2) + 2*q2(3)*x + q2(4)*y;
		gy =                     q2(4)*x + q2(5) + 2*q2(6)*y;
		d = fx*gy - fy*gx;
		t = fx + gy
		v1 = t/2 + sqrt((t/2)^2 - d);
		v2 = t/2 - sqrt((t/2)^2 - d);
	endfunction

	[lambda1 lambda2] = raices(x0(1),x0(2));
	line3 = "Valores propios = {" + string(lambda1) + "," + string(lambda2) + "}"
	rho = max(abs(lambda1), abs(lambda2));
    if  rho > 1 then
        line4 = "Inestable"
    elseif rho < 1 then
        line4 = "Estable"
    else
        line4 = "Se requiere mayor análisis"
    end
	messagebox([msg line2 line3 line4], "Puntos fijos", "info", "modal");

endfunction

function Graficar_orbitas()

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

	xinfo("Seleccione el punto inicial");
	seed = locate(1,1);   //user clicks the location of the seed
	labels = ['k'];
	[ok, k] = getvalue("Ingrese número de iteraciones", labels,list("vec",1), ["5"]);
	clear f g;
	f(1)=  seed(1);
	g(1)=  seed(2);

	for i = 1:k
		f(i+1)= pol2(q1,f(i),g(i));
		g(i+1)= pol2(q2,f(i),g(i));
	end;

	t = [1:1:k];
	plot2d4(f(t),g(t));
	xstring(f(1),g(1)-0.2,"$x_0$");
	handletext = get("hdl");
	handletext.font_size = 2;
	xinfo("La órbita muestra las " + string(k) + " primeras iteraciones");

endfunction

function exponenteL()

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

	eps = 1e-6;
	clear f g fe ge dist;
	xinfo("Haga click en donde desea evaluar el exponente");
	seed = locate(1,1);
	f(1) = pol2(q1,seed(1),seed(2));
	g(1) = pol2(q2,seed(1),seed(2));
	fe(1)= f(1);
	ge(1)= g(1)-eps;
	expL = 0;
//Updated condition on distance, Jun 10th 2020
	for k = 1:100
		f(k+1)= pol2(q1, f(k),g(k));
		g(k+1)= pol2(q2, f(k),g(k));
		fe(k+1)= pol2(q1, fe(k),ge(k));
		ge(k+1)= pol2(q2, fe(k),ge(k));
		dist = ((f(k+1)-fe(k+1))^2 + (g(k+1)-ge(k+1))^2)^0.5;
		if dist > 0 then
			rs = eps/dist;
			fe(k+1)= f(k+1) + rs*(fe(k+1)- f(k+1));
			ge(k+1)= g(k+1) + rs*(ge(k+1)- g(k+1));
			expL = expL + log2(dist);
		end;
	end;

	expL = expL/(100-1) - log2(eps);

	format(5);
	msg = "Exponente de Lyapunov en (" + string(seed(1))+ ", " + string(seed(2)) + ") ="
	msg = msprintf('%s \n %f',msg,expL);
	messagebox(msg, "Exponente de Lyapunov", "info", "modal");
	xinfo("");

endfunction

function curvas_criticas()  //Gardini, 1997
//Defined as det(J) = 0

    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end
    obj = findobj("tag", "r_esc");
    r = evstr(obj.string);

	x = linspace(-r,r,20*r); //size of the curve matches graph size
	y = linspace(-r,r,20*r);

	function d = ccrit(x,y)
		fx = q1(2) + 2*q1(3)*x + q1(4)*y;
		fy =                         q1(4)*x + q1(5) + 2*q1(6)*y;
		gx = q2(2) + 2*q2(3)*x + q2(4)*y;
		gy =                         q2(4)*x + q2(5) + 2*q2(6)*y;
		d = fx*gy - fy*gx;
	endfunction

	xset("fpf", " ");
	contour2d(x,y,ccrit,[0,0],[3,3]);

	xinfo("Curva crítica graficada en color verde");
//	legends("$\det(J) = 0$",3,opt=5,with_box=%t, font_size =3);

endfunction

function evolution()

    delete(gca());
    my_plot_axes = gca();
    my_plot_axes.title.font_size = 3;
    my_plot_axes.axes_bounds = [0.3 0 0.7 1];//[x_left,y_up,width,height]
    
    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

    niterobj = findobj("tag", "niter");
    niter = niterobj.value;
    
    seed = ['x_0';'y_0'];
    [ok, x_0, y_0] = getvalue("Ingrese el punto inicial", seed,list("vec",1,"vec",1), ["0" ;"-1.5"]);
    my_plot_axes.title.text = "Evolución del sistema desde (" + string(x_0)+ ", "+ string(y_0) + ")";
    
    f(1) = x_0;
    g(1) = y_0;

    for k = 1:niter
		f(k+1)= pol2(q1, f(k),g(k));
		g(k+1)= pol2(q2, f(k),g(k));
    end;
    
    t = [1:1:niter];
    
    plot2d4(t-1,f(t),color("blue"));
    plot2d4(t-1,g(t),color("red"));

    xgrid(color("gray"),1);
    xlabel("$k$","fontsize",4);
    xinfo("Color series x: azul, y: rojo");

endfunction

function prender_apagar()

	my_plot_axes = gca();
	user_choice = x_choose(['x';'y'],"Serie a apagar:")
	select user_choice
		case 1 then
		my_plot_axes.children(2).visible = "off"
		case 2 then
		my_plot_axes.children(1).visible = "off"
	end;

endfunction

function z = extr(q); //q is a vector

    numerator1 = q(4)*q(5)-2*q(2)*q(6)
    numerator2 = q(2)*q(4)-2*q(3)*q(5)
    denominator = 4*q(3)*q(6)-q(4)*q(4)
    if denominator <> 0 then
        x = numerator1/denominator
        y = numerator2/denominator
        z = pol2(q,x,y);
    end

endfunction

function analisis_global()
//classify quadratic form according to discriminant
    for k =1:6
        obj = findobj("tag", labels_a(k));
        q1(k) = evstr(obj.string);
    end
    for k =1:6
        obj = findobj("tag", labels_b(k));
        q2(k) = evstr(obj.string);
    end

    discrim_f = q1(3) * q1(6) - (q1(4)/2)^2;
    discrim_g = q2(3) * q2(6) - (q2(4)/2)^2;

    if (q1(3))^2+(q1(6))^2+(q1(4))^2 == 0 then
        str_f = "f es lineal";
    else
        if discrim_f > 0 then
            str_f = "f es definida (tiene un punto extremo)";
            extr_f = extr(q1);
        else
            if discrim_f < 0 then
                str_f = "f es indefinida (tiene un punto silla)"
            else
                str_f = "f es semidefinida (es un cilindro)"
            end;
        end;
    end;

    if (q2(3))^2+(q2(6))^2+(q2(4))^2 == 0 then
        str_g = "g es lineal"
    else
        if discrim_g > 0 then
            str_g = "g es definida (tiene un punto extremo)";
            extr_g = extr(q2);
        else
            if discrim_g < 0 then
                str_g = "g es indefinida (tiene un punto silla)"
            else
                str_g = "g es semidefinida (es un cilindro)"
            end;
        end;
    end;

    if (discrim_f > 0) & (discrim_g > 0) then 
        str_caos = "Valor extremo de f = " + string(extr_f) + "; valor extremo de g = " + string(extr_g)
    else
        str_caos = "Caos no es posible en ningún punto de la región de no-divergencia"
    end;
    
	globalw = figure("figure_name", "Análisis global de las funciones componentes", ...
	"toolbar_visible", "off", ...
	"infobar_visible", "off", ...
	"backgroundcolor", [1 1 1], ...
	"figure_size", [640 200], ...
	"figure_position", [0 0], ...
	"dockable", "off");

	delmenu(globalw.figure_id,gettext("&File"));
	delmenu(globalw.figure_id,gettext("&Tools"));
	delmenu(globalw.figure_id,gettext("&Edit"));
	delmenu(globalw.figure_id,gettext("&?"));

	frame_equation = uicontrol(globalw, "style", "frame",...
	"position",[40,40,600,80],...//[x left bottom, y left bottom, w, h] 
	"layout_options", createLayoutOptions("grid",[3,1]),...
	"layout","grid");

	uicontrol(frame_equation,"style","text",...
	"string", str_caos, ...
	"horizontalalignment", "left",...
	"backgroundcolor", [1 1 1], ...
	"fontsize",16);
	uicontrol(frame_equation,"style","text",...
	"string", str_g, ...
	"horizontalalignment", "left",...
	"backgroundcolor", [1 1 1], ...
	"fontsize",16);
	uicontrol(frame_equation,"style","text",...
	"string", str_f,...
	"horizontalalignment","left",...
	"backgroundcolor", [1 1 1], ...
	"fontsize",16);

endfunction
