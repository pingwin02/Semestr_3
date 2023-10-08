var container;
var camera, scene, renderer;
var width, height;

var cube_mesh, cylinder_mesh;

//Tworzenie sceny

function rad(degree){
	return degree*3.14159/180;
}

function init(){

    container = document.getElementById("div_webgl");
	width = container.offsetWidth;
	height = container.offsetHeight;

	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera( 75, width / height, 1, 1000 );
	renderer = new THREE.WebGLRenderer();
	renderer.setSize(width, height);
	container.appendChild(renderer.domElement);
	camera.position.set(0, 0, 17);

	//definicja prostopadłościanu 
	var cube = new THREE.CubeGeometry(7, 7, 7); 
	//definicja materiału 
	var material1 = new THREE.MeshPhongMaterial  ( {color: 0x0000FF, specular: 0x55555 } ); 
	var myvideo = document.getElementById("movie");
	var texture = new THREE.VideoTexture(myvideo);
	texture.minFilter = THREE.LinearFilter;
	var material2 = new THREE.MeshBasicMaterial({ map: texture });

	var materials = [ material1, material1, material1, material1, material2, material1 ];
	cube_mesh = new THREE.Mesh( cube, new THREE.MeshFaceMaterial(materials)); 
	cube_mesh.rotation.set(rad(15), rad(40), 0);
	cube_mesh.position.set(-7, 0, 0);
	scene.add( cube_mesh );

	//cylinder
	var cylinder = new THREE.CylinderGeometry ( 2, 2, 7, 30); 
	var material3 = new THREE.MeshLambertMaterial ({color: 0xFF0000 });
	cylinder_mesh = new THREE.Mesh( cylinder, material3 ); 
	cylinder_mesh.rotation.set(rad(15), 0, 0);
	cylinder_mesh.position.set(7, 0, 0);
	scene.add( cylinder_mesh );


	var light = new THREE.DirectionalLight(0xffffff, 1); 
	//światło kierunkowe o określonej barwie i intensywności 
	light.position.set(0, 5, 10).normalize; 
	//światło kierunkowe nie ma pozycji, w tym wypadku podane parametry  
	//służą do obliczenia kierunek padania światła 
	scene.add( light ); 
	//dodanie światła do scen


	render();	
}

//Rysowanie
function render() {
	cube_mesh.rotation.x+=rad(0.25);
	cube_mesh.rotation.y+=rad(0.25);
	renderer.render(scene, camera);
	requestAnimationFrame(render);
}

//Zmiana rozmiaru
function onWindowResize() {
    width = document.getElementById("div_webgl").offsetWidth;
    height = document.getElementById("div_webgl").offsetHeight;
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height);
  }
