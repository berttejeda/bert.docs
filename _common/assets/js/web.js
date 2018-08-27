 function openURL(url)
{
  console.log(String.format("openURL({0})", url))
  WshShell.run(url);
}