module ApplicationHelper
  
  def get_hostname()
    Rails.env.development? ? 'fhsim' : Socket.gethostname
  end

  def assoc_tree( obj )
    # Create level 1 tree
    result = []
    assocs = []
    obj.associations.keys.each do |x|
      assocs << x unless obj.associations[x].class.to_s.include?("BelongsTo")
    end
    # Add pseudo-associations: identified by key ending in '_id(s)'
    # but exclude '_id' itself and the parent id if there's a 'belongs to'
    # association.
    obj.keys.keys.select { |x|
      !x.eql?( '_id' ) && 
      !obj.associations[x.split("_id")[0].to_sym].class.to_s.include?("BelongsTo") && 
      x.singularize.end_with?( '_id' ) }.each {|x| assocs << x.to_sym}
    assocs.each do |x|
      parent_class = obj.class.to_s
      parent_id = obj.id.to_s
      is_pseudo = x.to_s.singularize.end_with?( '_id' )
      klass_key = is_pseudo ? 
                  x.to_s.singularize.rpartition( '_id' )[0].to_sym : x
      assoc_klass = klass_key.to_s.singularize.titleize.split.join
      if is_pseudo
        ids = eval( 'obj.' + x.to_s )
        assoc_objs = eval( assoc_klass + '.find( ids )' ) 
      else        
        assoc_objs = eval( 'obj.' + x.to_s )
      end
      if is_pseudo
        assoc_type = x.to_s.end_with?( 's' ) ? 'Many' : 'One'
      else
        assoc_type = 
          eval(parent_class).associations[x].to_s.split(":")[6].split('Association')[0]
      end
      has_objs = false # Flag used to allow at least a nil placeholder
      unless assoc_objs.class == Array
        result << [1, parent_class, parent_id, assoc_type, 
                   assoc_klass, assoc_objs ]
        has_objs = true
      else
        assoc_objs.each do |y|
          result << [1, parent_class, parent_id, assoc_type, y.class.to_s, y ]
          has_objs = true
        end
      end
      result << [1, parent_class, parent_id, assoc_type, assoc_klass, 
                 nil] unless has_objs
    end
    result.each do |r|
    end
    
    # Drill down
    result.each_with_index do |x, i|
      insert = i + 1
      level = x[0]
      klass = x[4]
      object = x[5]
      assocs = eval(klass).associations.keys
      # Add pseudo-associations: identified by key ending in '_id(s)'
      # but exclude '_id' itself and the parent id if there's a 'belongs to'
      # association.
      eval(klass).keys.keys.select { |k| 
        !k.eql?( '_id' ) && 
        !k.eql?( x[1].underscore + '_id' ) && 
        k.singularize.end_with?( '_id' ) }.each { |kk| assocs << kk.to_sym}
      assocs.each_with_index do |y,j|
        is_pseudo = y.to_s.singularize.end_with?( '_id' )
        klass_key = is_pseudo ? 
          y.to_s.singularize.rpartition( '_id' )[0].to_sym : y
        if is_pseudo
          assoc = y.to_s.end_with?( 's' ) ? 'Many' : 'One'
        else
          assoc = eval("#{klass}.associations[:#{y.to_s}]")
                        .to_s.split(":")[6].split('Association')[0]
        end
        sub_klass = klass_key.to_s.singularize.titleize.split.join
        parent_id = object ? object.id.to_s : nil
        unless eval(sub_klass).keys['no_edit']
          if ( assoc == 'One' )
            if is_pseudo
              ids = object ? eval( 'object.' + y.to_s ) : nil
              assoc_objs = eval( sub_klass + '.find( ids )' )
            else
              assoc_objs = object ? eval( 'object.' + y.to_s ) : nil
            end
            result.insert( 
              insert, 
              [ level + 1, klass, parent_id, assoc, sub_klass, assoc_objs ] )
            insert += 1
          end
          if assoc == 'Many'
            if is_pseudo
              ids = object ? eval( 'object.' + y.to_s ) : nil
              assoc_objs = ids ? eval( sub_klass ).find( ids ) : []
            else
              assoc_objs = object ? eval( 'object.' + y.to_s ) : []
            end
            parent_id = object ? object.id.to_s : nil
            if assoc_objs.count > 0 
              assoc_objs.each_with_index do |z,k|
                result.insert( 
                  insert, 
                  [ level + 1, klass, parent_id, 
                    assoc, y.to_s.singularize.titleize.split.join, z ] )
                insert += 1
              end
            else
              result.insert( insert, 
                [ level + 1, klass, parent_id, 
                  assoc, y.to_s.singularize.titleize.split.join, nil ] )
              insert += 1
            end
          end
        end
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
