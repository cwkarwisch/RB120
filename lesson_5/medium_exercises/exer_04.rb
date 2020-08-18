class CircularQueues2

  attr_accessor :oldest_element_index, :current_index

  def initialize(size)
    @queue = Array.new(size)
    @oldest_element_index = 0
    @current_index = 0
    @size = size
  end

  def enqueue(value)
    increment_oldest_element_index unless queue[current_index].nil?
    queue[current_index] = value
    increment_current_index
  end

  def dequeue
    oldest_element = queue[oldest_element_index]
    queue[oldest_element_index] = nil
    increment_oldest_element_index unless oldest_element.nil?
    oldest_element
  end

  def to_s
    queue.to_s
  end

  private

  attr_reader :queue, :size

  def next_current_index
    case current_index
    when 0..(size - 2) then current_index + 1
    when size - 1 then 0
    end
  end

  def next_oldest_element_index
    case oldest_element_index
    when 0..(size - 2) then oldest_element_index + 1
    when size - 1 then 0
    end
  end

  def increment_current_index
    self.current_index = next_current_index
  end

  def increment_oldest_element_index
    self.oldest_element_index = next_oldest_element_index
  end
end

class CircularQueue

  def enqueue(value)
    if any_nils_in_queue?
      queue.each_with_index do |element, index|
        if element.nil?
          queue[index] = value
          break
        end
      end
    else
      queue.shift
      queue.push(value)
    end
  end

  def dequeue
    if all_nils_in_queue?
      nil
    else
      queue.push(nil)
      queue.shift
    end
  end

  private

  def initialize(size)
    @queue = Array.new(size)
    @size = size
  end

  attr_reader :queue, :size

  def any_nils_in_queue?
    queue.any?(&:nil?)
  end

  def all_nils_in_queue?
    queue.all?(&:nil?)
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3) #[2, 3, nil]
queue.enqueue(4) #[2, 3, 4]
puts queue.dequeue == 2 #[3, 4, nil]

queue.enqueue(5) #[3, 4, 5]
queue.enqueue(6) #[4, 5, 6]
queue.enqueue(7) #[5, 6, 7]
puts queue.dequeue == 5 #[6, 7, nil]
puts queue.dequeue == 6 #[7, nil, nil]
puts queue.dequeue == 7 #[nil, nil, nil]
puts queue.dequeue == nil #[nil, nil, nil]

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
