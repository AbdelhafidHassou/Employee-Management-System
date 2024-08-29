package abdelhafidhassou.employeemanagementsystem.repository.implementation;

import abdelhafidhassou.employeemanagementsystem.exception.ApiException;
import abdelhafidhassou.employeemanagementsystem.model.Role;
import abdelhafidhassou.employeemanagementsystem.model.User;
import abdelhafidhassou.employeemanagementsystem.repository.RoleRepository;
import abdelhafidhassou.employeemanagementsystem.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static abdelhafidhassou.employeemanagementsystem.enumeration.RoleType.ROLE_USER;
import static abdelhafidhassou.employeemanagementsystem.enumeration.VerificationType.ACCOUNT;
import static abdelhafidhassou.employeemanagementsystem.query.UserQuery.*;
import static java.util.Objects.*;

@Repository
@RequiredArgsConstructor
@Slf4j
public class UserRepositoryImp implements UserRepository<User> {
    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final RoleRepository<Role> roleRepository;
    private final BCryptPasswordEncoder encoder;

    @Override
    public User create(User userData) {
        // Check if the email is in use
        if(getEmailCount(userData.getEmail().trim().toLowerCase()) > 0) throw new ApiException("Email already exist. use a different email and try again.");
        // Save a new user
        try {
            KeyHolder holder = new GeneratedKeyHolder();
            SqlParameterSource params = getSqlParameterSource(userData);
            jdbcTemplate.update(INSERT_USER_QUERY, params, holder);
            userData.setUserId(requireNonNull(holder.getKey()).longValue());
            // Add role to the user
            roleRepository.addRoleToUser(userData.getUserId(), ROLE_USER.name());
            // Send verification URL to user
            String verification = getVerificationUrl(UUID.randomUUID().toString(), ACCOUNT.getType());
        } catch (EmptyResultDataAccessException exception) {

        } catch (Exception exception) {

        }
        return null;
    }



    @Override
    public Collection<User> list(int page, int size) {
        return List.of();
    }

    @Override
    public User get(Long id) {
        return null;
    }

    @Override
    public User update(User data) {
        return null;
    }

    @Override
    public Boolean delete(Long id) {
        return null;
    }

    private Integer getEmailCount(String email) {
         return jdbcTemplate.queryForObject(COUNT_USER_EMAIL_QUERY, Map.of("email", email), Integer.class);
    }

    private SqlParameterSource getSqlParameterSource(User user) {
        return new MapSqlParameterSource()
                .addValue("firstName", user.getFirstName())
                .addValue("lastName", user.getLastName())
                .addValue("email", user.getEmail())
                .addValue("password", encoder.encode(user.getPassword()));
    }

    public String getVerificationUrl(String key, String type) {

    }
}
