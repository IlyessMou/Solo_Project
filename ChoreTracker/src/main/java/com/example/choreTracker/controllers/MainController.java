package com.example.choreTracker.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.choreTracker.models.Job;
import com.example.choreTracker.models.LoginUser;
import com.example.choreTracker.models.User;
import com.example.choreTracker.services.JobService;
import com.example.choreTracker.services.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class MainController {

    @Autowired
    private UserService userService;

    @Autowired
    private JobService jobService;

    //login/register page
    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("newUser", new User());
        model.addAttribute("newLogin", new LoginUser());
        return "index.jsp";
    }

    // Register
    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("newUser") User newUser, 
                           BindingResult result, Model model, HttpSession session) {
        User user = userService.register(newUser, result);
        if (result.hasErrors()) {
            model.addAttribute("newLogin", new LoginUser());
            return "index.jsp";
        }
        session.setAttribute("userId", user.getId());
        return "redirect:/home";
    }

    // Login 
    @PostMapping("/login")
    public String login(@Valid @ModelAttribute("newLogin") LoginUser newLogin, 
                        BindingResult result, Model model, HttpSession session) {
        User user = userService.login(newLogin, result);
        if (result.hasErrors()) {
            model.addAttribute("newUser", new User());
            return "index.jsp";
        }
        session.setAttribute("userId", user.getId());
        return "redirect:/home";
    }

    // Home page
    @GetMapping("/home")
    public String home(Model model, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }

        Long userId = (Long) session.getAttribute("userId");
        User user = userService.findById(userId);

        List<Job> userJobs = jobService.findJobsByUserId(userId);


        List<Job> availableJobs = jobService.findAvailableJobs(userId);

        model.addAttribute("user", user);
        model.addAttribute("userJobs", userJobs); 
        model.addAttribute("availableJobs", availableJobs); 

        return "home.jsp";
    }

    // form to add a new job
    @GetMapping("/jobs/new")
    public String addJobPage(@ModelAttribute("job") Job job, Model model, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        return "addJob.jsp";
    }

    // Create a new job
    @PostMapping("/jobs")
    public String createJob(@Valid @ModelAttribute("job") Job job, 
                            BindingResult result, HttpSession session) {
        if (result.hasErrors()) {
            return "addJob.jsp";
        }
        Long userId = (Long) session.getAttribute("userId");
        job.setCreatedBy(userService.findById(userId)); 
        jobService.saveJob(job);
        return "redirect:/home";
    }

    // Display details of a job
    @GetMapping("/jobs/{id}")
    public String showJob(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        Job job = jobService.findById(id);
        if (job == null) {
            return "redirect:/home";
        }
        model.addAttribute("job", job);
        return "jobDetails.jsp";
    }

    @GetMapping("/jobs/{id}/edit")
    public String editJob(@PathVariable("id") Long id, Model model, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        Job job = jobService.findById(id);
        if (job == null) {
            return "redirect:/home";
        }

        Long userId = (Long) session.getAttribute("userId");
        if (!job.getCreatedBy().getId().equals(userId)) {
            return "redirect:/home"; 
        }

        model.addAttribute("job", job);
        return "editJob.jsp";
    }

    // Update job
    @PostMapping("/jobs/{id}/update")
    public String updateJob(@PathVariable("id") Long id, 
                            @Valid @ModelAttribute("job") Job job, 
                            BindingResult result, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        if (result.hasErrors()) {
            return "editJob.jsp";
        }
        Job existingJob = jobService.findById(id);
        if (existingJob != null) {
            Long userId = (Long) session.getAttribute("userId");
            
            if (!existingJob.getCreatedBy().getId().equals(userId)) {
                return "redirect:/home"; 
            }
            existingJob.setTitle(job.getTitle());
            existingJob.setDescription(job.getDescription());
            existingJob.setLocation(job.getLocation());
            existingJob.setReward(job.getReward());


            existingJob.setLatitude(job.getLatitude());
            existingJob.setLongitude(job.getLongitude());

            jobService.update(existingJob); 
        }
        return "redirect:/home";
    }


    // Assign a job to the  user
    @PostMapping("/jobs/{id}/addToMyJobs")
    public String addToMyJobs(@PathVariable("id") Long id, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        Long userId = (Long) session.getAttribute("userId");
        jobService.assignJobToUser(id, userId);
        return "redirect:/home";
    }

    // Mark a job as completed 
    @PostMapping("/completeJob/{jobId}/{userId}")
    public String completeJob(@PathVariable Long jobId, @PathVariable Long userId, 
                              @ModelAttribute Job job, BindingResult result) {
        if (result.hasErrors()) {
            return "errorPage";  
        }

        Job completedJob = jobService.completeJob(jobId, userId);

        if (completedJob == null) {
            return "errorPage";  
        }

        return "redirect:/home";
    }
    
    // Unclaim a job 
    @PostMapping("/jobs/{id}/unclaim")
    public String unclaimJob(@PathVariable("id") Long id, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }

        jobService.unclaimJob(id);

        return "redirect:/home"; 
    }





    // Delete a job
    @GetMapping("/jobs/delete/{id}")
    public String deleteJob(@PathVariable("id") Long id, HttpSession session) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }
        Job job = jobService.findById(id);
        if (job != null) {
            Long userId = (Long) session.getAttribute("userId");
            if (!job.getCreatedBy().getId().equals(userId)) {
                return "redirect:/home"; 
            }
            jobService.delete(id);
        }
        return "redirect:/home";
    }
    // Get jobs completed by user
    @GetMapping("/jobs/completed")
    public String getCompletedJobs(HttpSession session, Model model) {
        if (session.getAttribute("userId") == null) {
            return "redirect:/";
        }

        Long userId = (Long) session.getAttribute("userId");
        User user = userService.findById(userId);
        List<Job> completedJobs = jobService.findCompletedJobsByUserId(userId); 
        
        model.addAttribute("user", user);
        model.addAttribute("completedJobs", completedJobs); 
        return "completedJobs.jsp"; 
    }

    // Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
