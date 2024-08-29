package abdelhafidhassou.employeemanagementsystem.repository;

import abdelhafidhassou.employeemanagementsystem.model.Role;

import java.util.Collection;

public interface RoleRepository <U extends Role>{
    U create (U data);
    Collection<U> list(int page, int size);
    U get (Long id);
    U update (U data);
    Boolean delete (Long id);

    void addRoleToUser(Long userId, String roleName);
}
