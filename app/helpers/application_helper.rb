module ApplicationHelper

  def assoc_tree( obj )
    # Create level 1 tree
    result = []
    obj.associations.keys.each do |x|
      puts "key=#{x.to_s}"
      parent_class = obj.class.to_s
      parent_id = obj.id.to_s
      assoc_klass = x.to_s.singularize.titleize.split.join
      assoc_objs = eval( 'obj.' + x.to_s )
      assoc_type = assoc_objs.association.to_s.split(":")[6].split('Association')[0]
      has_objs = false # Flag used to allow at least a nil placeholder
      assoc_objs.each do |y|
        result << [1, parent_class, parent_id, assoc_type, y.class.to_s, y ]
        has_objs = true
      end
      result << [1, parent_class, parent_id, assoc_type, assoc_klass, nil] unless has_objs
   end
    puts 'First level:'
    result.each do |r| 
      puts (r[0..4] << ( r[5] ? r[5]["_id"].to_s : 'nil' ) ).to_s
    end
    puts ''
    result.each_with_index do |x, i|
      insert = i + 1
      level = x[0]
      klass = x[4]
      object = x[5]
      #puts ''
      puts "i=#{i} class=#{klass}" 
      eval(klass).associations.keys.each_with_index do |y,j|
        assoc = eval("#{klass}.associations[:#{y.to_s}]").to_s.split(":")[6].split('Association')[0]
        sub_klass = y.to_s.singularize.titleize.split.join
        parent_id = object ? object.id.to_s : nil
        puts "#{level+1}, #{klass}, #{parent_id}, #{assoc}, #{sub_klass}"
        #unless eval(sub_klass).keys['no_edit']
          if ( assoc == 'One' )
            #puts "class:#{sub_klass} parent:#{klass} parent_id:#{parent_id}"
            assoc_objs = object ? eval( 'object.' + y.to_s ) : nil
            result.insert( insert, [ level + 1, klass, parent_id, assoc, sub_klass, assoc_objs ] )
            insert += 1
          end
          if assoc == 'Many'
            #puts "class:#{sub_klass} parent:#{klass} parent_id:#{parent_id}"
            assoc_objs = object ? eval( 'object.' + y.to_s ) : []
            parent_id = object ? object.id.to_s : nil
            if assoc_objs.count > 0 
              assoc_objs.each_with_index do |z,k|
                result.insert( insert, [ level + 1, klass, parent_id, assoc, y.to_s.singularize.titleize.split.join, z ] )
                insert += 1
              end
            else
              result.insert( insert, [ level + 1, klass, parent_id, assoc, y.to_s.singularize.titleize.split.join, nil ] )
              insert += 1
            end
          end
        #end
      end
      #puts ''
    end
      result.each_with_index do |z,k|
        #puts "#{k} #{z[0..4]} #{z[5] ? z[5]['_id'] : 'nil' }"
      end
    return result
  end
  
  def plural? str
    return str.pluralize == str
  end

end
