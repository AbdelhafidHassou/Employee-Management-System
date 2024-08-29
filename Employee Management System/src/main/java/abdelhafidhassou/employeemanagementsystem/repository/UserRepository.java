package abdelhafidhassou.employeemanagementsystem.repository;

import abdelhafidhassou.employeemanagementsystem.model.User;

import java.util.Collection;

public interface UserRepository <U extends User> {
    U create (U data);
    Collection <U> list(int page, int size);
    U get (Long id);
    U update (U data);
    Boolean delete (Long id);
}
