#studentRequest can act as a proxy between student and tutor
class StudentRequest < ActiveRecord::Base
  belongs_to :tutor
  belongs_to :student

  def self.get_active_queues
    waiting = StudentRequest.where(status: "waiting").order('created_at')
  	[waiting.where(meet_type: "drop-in"), waiting.where(meet_type: "scheduled"), waiting.where(meet_type: "weekly"),
  	  StudentRequest.where(status: "active").order('created_at')]
  end

  def self.send_email_next_in_line
    #send an email to next person who hasn't been emailed yet
    @next_student_in_line = StudentRequest.where(:emailed => false)[0]

    unless @next_student_in_line == nil
      @studentid = @next_student_in_line.student_id
      @student = Student.find(@studentid)
      ExampleMailer.next_in_line_email(@student).deliver_now
      StudentRequest.where(:student_id => @studentid)[0].update(:emailed => true)
    end

  end

  def self.tutor_has_time_to_help?(time_to_leave,time_to_help)
    if(time_to_leave-time_to_help)/60 > 30
      return true
    end
    return false
  end



  def self.calculate_wait_time
    help_queue = Array.new()
    active_tutors = Tutor.where(active: true)
    active_tutors.each do |tutor|
      start_time = Time.now
      if tutor.is_tutoring?
        start_time = tutor.get_time_tutor_can_help
      end
      help_queue.push({start_time: start_time, sid: tutor.sid, edt: tutor.expected_leave_time})
    end
    if help_queue.length == 0
      return nil
    end
    help_queue = help_queue.sort_by {|tutor| tutor["start_time".to_sym]}
    num_in_line = StudentRequest.where(meet_type: "drop-in").where(status: "waiting").count+1 #+1 because that represents the new student

    for i in 0...num_in_line
      j = i%help_queue.length
      helped = false
      while(helped == false)
        tutor_time = help_queue[j]
        if StudentRequest.tutor_has_time_to_help?(tutor_time["edt".to_sym].to_time,tutor_time["start_time".to_sym])
          help_queue[j]["start_time".to_sym] = tutor_time["start_time".to_sym] + 30 * 60
          helped = true
        else
          help_queue.delete_at(j)
          if help_queue.length == 0
            return nil
          end
          j = j%help_queue.length #will set index to next tutor in help_queue
        end
      end
    end
    return help_queue[j]["start_time".to_sym] - 30*60
  end
end

