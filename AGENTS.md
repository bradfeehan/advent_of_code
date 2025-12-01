
### Elixir Conventions
- Write idiomatic Elixir, utilising language features for what they're best at
    - This includes pipelines, pattern matching and guards, structs, protocols, streams, enumerations, collectables, comprehensions, processes, concurrency, etc. where appropriate.
    - Avoid writing "Elixir-flavoured Python" or drifting away from a more elegant overall solution
- Follow Elixir idioms and patterns with clear public APIs
- Use `with` statements for complex operations with multiple failure points
- Prefer explicit error tuples `{:ok, result}` / `{:error, reason}`
- Avoid nested data types e.g. `{:ok, {:ok, result}}`
- Pattern matching is powerful and idiomatic, can be used on function heads for clear control flow
- Use `@spec` for all public functions
- Document modules with `@moduledoc` and functions with `@doc`
- Keep functions focused with single responsibility

### Dependencies
- Consider if an open source package exists before implementing a significant subsystem
- Use the following sources to find popular dependencies:
    - https://elixirtoolbox.dev
    - https://github.com/h4cc/awesome-elixir
- Not all dependencies are worth using, especially if not very popular, outdated or incomplete, or not so relevant.
- Use `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`.

### Testing Patterns
- Code should be testable and highly tested
- Group tests with `describe` blocks
- Test both success and failure cases
- Use `assert` and `refute` appropriately
- Mock external dependencies in tests

### Control Flow
```elixir
# Use with statements for complex operations
with {:ok, validated_data} <- validate_data(data),
     {:ok, item} <- create_item(validated_data),
     {:ok, _result} <- perform_calculation(item) do
  {:ok, item}
else
  {:error, reason} -> {:error, reason}
end
```

Too many extracted methods can obscure the control flow (e.g. `validate_data`, `create_item` above).
When building a `with` block like the above, ideally these private methods aren't calling a myriad of other modules.
The public API should be minimal and simple, with the public method handling fetching data from external modules,
and processing using other modules' public API, together with its own internal private methods.

## Testing Guidelines

### Test driven development philosophy

When writing a feature, always ensure it's fully tested from the start.
For any reasonably sized piece of functionality or bug fix, create a branch from latest `main` and:

- Write a test for the new functionality, and run it to make sure it fails
- Commit that and then work on the feature or change
- Write other lower-level tests along the way for each small testable part
- Repeat (check the test fails before implementing, do implementation and check it passes, commit)
- When the overall test passes, the work should be complete
- That test should be written in a way that it will fail if the functionality ever went away or doesn't work
- All bugfixes have a corresponding regression test which fails on `main`, but passes after the bug is fixed.

Only update test files themselves (i.e. changing what is being tested) if the test is actually no longer valid based on the changes we are making. Don't just make changes to tests to get them to pass without knowing why. In that case, consider keeping the test but inverted, if the inverse behaviour is the new desired behaviour.

### Test Organization
- Testing pyramid philosophy: lots of fast unit tests with mocks, fewer thorough integration tests
- At the top of the pyramid, a key set of comprehensive end-to-end acceptance tests ensure all features work
- Use `describe` blocks to group related tests
- Test both success and error paths
- Use factories for consistent test data
- Mock external dependencies (HTTP calls, APIs) accurately

### Documentation
- Keep architectural documents up to date, including this one
- Document all public API functions
- Include examples in documentation
- Use doctests for testable examples


## Elixir guidelines

- Elixir lists **do not support index based access via the access syntax**

  **Never do this (invalid)**:

      i = 0
      mylist = ["blue", "green"]
      mylist[i]

  Instead, **always** use `Enum.at`, pattern matching, or `List` for index based list access, ie:

      i = 0
      mylist = ["blue", "green"]
      Enum.at(mylist, i)

- Elixir variables are immutable, but can be rebound, so for block expressions like `if`, `case`, `cond`, etc
  you *must* bind the result of the expression to a variable if you want to use it and you CANNOT rebind the result inside the expression, ie:

      # INVALID: we are rebinding inside the `if` and the result never gets assigned
      if connected?(socket) do
        socket = assign(socket, :val, val)
      end

      # VALID: we rebind the result of the `if` to a new variable
      socket =
        if connected?(socket) do
          assign(socket, :val, val)
        end

- **Never** nest multiple modules in the same file as it can cause cyclic dependencies and compilation errors
- **Never** use map access syntax (`changeset[:field]`) on structs as they do not implement the Access behaviour by default. For regular structs, you **must** access the fields directly, such as `my_struct.field` or use higher level APIs that are available on the struct if they exist, `Ecto.Changeset.get_field/2` for changesets
- Elixir's standard library has everything necessary for date and time manipulation. Familiarize yourself with the common `Time`, `Date`, `DateTime`, and `Calendar` interfaces by accessing their documentation as necessary. **Never** install additional dependencies unless asked or for date/time parsing (which you can use the `date_time_parser` package)
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Predicate function names should not start with `is_` and should end in a question mark. Names like `is_thing` should be reserved for guards
- Elixir's builtin OTP primitives like `DynamicSupervisor` and `Registry`, require names in the child spec, such as `{DynamicSupervisor, name: MyApp.MyDynamicSup}`, then you can use `DynamicSupervisor.start_child(MyApp.MyDynamicSup, child_spec)`
- Use `Task.async_stream(collection, callback, options)` for concurrent enumeration with back-pressure. The majority of times you will want to pass `timeout: :infinity` as option

## Mix guidelines

- Read the docs and options before using tasks (by using `mix help task_name`)
- To debug test failures, run tests in a specific file with `mix test test/my_test.exs` or run all previously failed tests with `mix test --failed`
- `mix deps.clean --all` is **almost never needed**. **Avoid** using it unless you have good reason
