package com.edoctorspring;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class HelloWorldController
{
    @RequestMapping("/")
    public String index()
    {
        return "Hello World";
    }
    @RequestMapping("/test")
    public String test()
    {
        return "test";
    }

}