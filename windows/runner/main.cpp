#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  HWND hwnd = FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW", L"wimi_app");
  if (hwnd != NULL) {
    ShowWindow(hwnd, SW_RESTORE);
    SetForegroundWindow(hwnd);
    return 0;
  }

  wchar_t szFlutterDartProject[256];
  if (GetEnvironmentVariable(L"FLUTTER_TEST", szFlutterDartProject, 256) == 0) {
    GetCurrentDirectory(256, szFlutterDartProject);
  }

  std::wstring project_path = szFlutterDartProject;
  std::wstring data_directory = project_path + L"\\data";
  std::wstring assets_path = project_path + L"\\build\\flutter_assets";
  std::wstring icu_data_path = project_path + L"\\data\\icudtl.dat";

  std::wstring cache_path = project_path + L"\\cache";
  std::wstring code_cache_path = cache_path + L"\\code_cache";

  if (DirectoryExists(cache_path)) {
    if (!DirectoryExists(code_cache_path)) {
      CreateDirectory(code_cache_path.c_str(), nullptr);
    }
  }

  flutter::DartProject project(L"data");
  project.set_dart_entrypoint_arguments({});

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"wimi_app", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
