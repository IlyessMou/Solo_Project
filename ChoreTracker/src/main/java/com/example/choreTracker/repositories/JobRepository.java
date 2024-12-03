package com.example.choreTracker.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.example.choreTracker.models.Job;
import com.example.choreTracker.models.Job.JobStatus;

public interface JobRepository extends CrudRepository<Job, Long> {
    
	
    List<Job> findByStatus(JobStatus status);

    List<Job> findByAssignedToId(Long userId);
    
    @Query("SELECT j FROM Job j WHERE j.assignedTo.id = :userId AND j.completed = false")
    List<Job> findJobsByUserIdAndNotCompleted(@Param("userId") Long userId);
    

    List<Job> findByAssignedToIsNullOrAssignedTo_IdNot(Long userId);
    

    List<Job> findByCompleted(Boolean completed);
    
    @Query("SELECT j FROM Job j WHERE j.assignedTo.id = :userId AND j.completed = true")
    List<Job> findCompletedJobsByUserId(@Param("userId") Long userId);

}

