// @ts-nocheck
"use client";

import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { ReactLenis, useLenis } from 'lenis/react';
import {MutableRefObject, useEffect, useRef, useState} from "react";
import {Calendar} from "@/components/ui/calendar";
import {Progress} from "@/components/ui/progress";
import {Button} from "@/components/ui/button";

import { Canvas,  useFrame } from '@react-three/fiber';
import { createRoot } from 'react-dom/client';

function Box(props: object) {
    // This reference gives us direct access to the THREE.Mesh object
    const ref = useRef(null)

    // Hold state for hovered and clicked events
    const [hovered, hover] = useState(false)
    const [clicked, click] = useState(false)
    // Subscribe this component to the render-loop, rotate the mesh every frame
    useFrame((state, delta) => (ref.current.rotation.x += delta))
    // Return the view, these are regular Threejs elements expressed in JSX
    return (
        <mesh
            {...props}
            ref={ref}
            scale={clicked ? 1.5 : 1}
            onClick={(event) => click(!clicked)}
            onPointerOver={(event) => hover(true)}
            onPointerOut={(event) => hover(false)}>
            <boxGeometry args={[1, 1, 1]} />
            <meshStandardMaterial color={hovered ? 'hotpink' : 'orange'} />
        </mesh>
    )
}

export default function Home() {
    const lenis = useLenis(({scroll}) => {

    });


    useEffect(() => {
        gsap.registerPlugin(ScrollTrigger);

        gsap.to(".blob", {
            scrollTrigger: {
                trigger: ".blob",
                toggleActions: "restart pause reverse pause",
            },
            x: 400,
            rotation: 360,
            duration: 1,
            scrub: true,
            start: "top bottom"
        });

        function raf(time) {
            lenis?.raf(time)
            requestAnimationFrame(raf)
        }

        requestAnimationFrame(raf)

    }, []);


    const buttonRef = useRef();


    return (
        <>
            <ReactLenis root options={
                {

                    smoothWheel: true,
                }
            }>
                <div className="
                blob text-center content-center
                text-black text-5xl absolute
                h-[100px] w-[100px]
                top-[2000px] left-[400px] bg-yellow-400">H</div>
                <Calendar></Calendar>
                <Progress value={50}></Progress>
                <Button ref={buttonRef}>Hello world</Button>
                <div className="h-[500px] w-[500px] bg-green-400">

                    <Canvas>
                        <ambientLight intensity={Math.PI / 2} />
                        <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} decay={0} intensity={Math.PI} />
                        <pointLight position={[-10, -10, -10]} decay={0} intensity={Math.PI} />
                        <Box position={[-1.2, 0, 0]} />
                        <Box position={[1.2, 0, 0]} />
                    </Canvas>
                </div>


            </ReactLenis>

        </>
    );
}