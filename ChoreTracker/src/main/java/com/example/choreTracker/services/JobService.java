package com.example.choreTracker.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.choreTracker.models.Job;
import com.example.choreTracker.models.Job.JobStatus;
import com.example.choreTracker.models.User;
import com.example.choreTracker.repositories.JobRepository;
import com.example.choreTracker.repositories.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class JobService {

    private final JobRepository jobRepository;

    public JobService(JobRepository jobRepository) {
        this.jobRepository = jobRepository;
    }

    public Job saveJob(Job job) {
        return jobRepository.save(job);
    }

    public void update(Job job) {
        jobRepository.save(job);
    }

    public Job findById(Long id) {
        return jobRepository.findById(id).orElse(null);
    }

    public void removeJobFromUser(Job job) {
        job.setAssignedTo(null);
        job.setStatus(JobStatus.AVAILABLE);  // Set status to AVAILABLE
        jobRepository.save(job);
    }

    // Find jobs assigned
    public List<Job> findJobsByUserId(Long userId) {
        return jobRepository.findJobsByUserIdAndNotCompleted(userId);
    }

    // Find available jobs
    public List<Job> findAvailableJobs(Long userId) {
        return jobRepository.findByStatus(JobStatus.AVAILABLE);
    }

    @Autowired
    private UserRepository userRepository;

    // Assign a job
    public void assignJobToUser(Long jobId, Long userId) {
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null) {
            throw new IllegalArgumentException("Job not found");
        }
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }

        job.setAssignedTo(user);
        job.setStatus(JobStatus.CLAIMED); 

        jobRepository.save(job);
    }
    
    @Transactional
    public Job completeJob(Long jobId, Long userId) {
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null) {
            System.out.println("Job not found for ID: " + jobId);
            return null;
        }
        if (job.getAssignedTo() == null || !job.getAssignedTo().getId().equals(userId)) {
            System.out.println("User is not authorized to complete this job");
            return null;
        }

        job.setCompleted(true);
        job.setStatus(JobStatus.COMPLETED);
        
        User assignedUser = job.getAssignedTo();
        assignedUser.addToBalance(job.getReward());

        jobRepository.save(job);
        userRepository.save(assignedUser);
        
        return job;
    }
    
    @Transactional
    public void unclaimJob(Long jobId) {
        Job job = jobRepository.findById(jobId).orElse(null);
        if (job == null) {
            throw new IllegalArgumentException("Job not found");
        }

        if (job.getAssignedTo() == null) {
            throw new IllegalArgumentException("Job is not claimed by any user");
        }

        job.setAssignedTo(null);
        job.setStatus(JobStatus.AVAILABLE);  


        jobRepository.save(job);
    }

    public List<Job> findCompletedJobsByUserId(Long userId) {
        return jobRepository.findCompletedJobsByUserId(userId);
    }


    public void delete(Long id) {
        if (jobRepository.existsById(id)) {
            jobRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("Job not found");
        }
    }
}
