"use client";

import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { ReactLenis, useLenis } from 'lenis/react';
import { useEffect } from "react";


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
            </ReactLenis>

        </>
    );
}