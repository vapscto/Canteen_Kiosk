using Windows.UI.Xaml.Controls;
using Windows.ApplicationModel.Core;
using Windows.UI.Xaml.Printing;
using Windows.Graphics.Printing;
using System.Threading.Tasks;
using System;
using Windows.Storage.Streams;

public sealed partial class MainPage : Page
{
    public MainPage()
    {
        this.InitializeComponent();
        LoadApplicationActions();
    }

    private void LoadApplicationActions()
    {
        var channel = new MethodChannel("printer_service");
        channel.SetMethodCallHandler(HandleMethodCall);
    }

    private async void HandleMethodCall(MethodCall methodCall, MethodChannel.Result result)
    {
        switch (methodCall.Method)
        {
            case "printPdfDocument":
                await PrintPdfDocument();
                break;
            case "cutPaper":
                await CutPaper();
                break;
            default:
                result.NotImplemented();
                break;
        }
    }

    private async Task PrintPdfDocument()
    {
        PrintManager printManager = PrintManager.GetForCurrentView();
        printManager.PrintTaskRequested += PrintTaskRequested;
        await PrintManager.ShowPrintUIAsync();
    }

    private void PrintTaskRequested(PrintManager sender, PrintTaskRequestedEventArgs args)
    {
        PrintTask printTask = args.Request.CreatePrintTask("Printing PDF", async (printTaskArgs) =>
        {
            var deferral = printTaskArgs.GetDeferral();
            printTaskArgs.SetSource(PrintDocumentSource.PrintStream, "Print Document");

            printTaskArgs.Options.MediaSize = PrintMediaSize.NorthAmericaLegal;
            printTaskArgs.Options.ColorMode = PrintColorMode.Monochrome;

            printTaskArgs.SetSource(PrintDocumentSource.PrintStream, "Print Document");
            deferral.Complete();
            await Task.CompletedTask;
        print Utf8 data
