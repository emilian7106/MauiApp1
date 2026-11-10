namespace MauiApp1
{
    public partial class MainPage : ContentPage
    {


        public MainPage()
        {
            InitializeComponent();
            // se sono arrivato qua l'xaml è pronto
            // come gestisco l'evento click del button?
            this.ButtonAddizione.Clicked += ButtonAddizione_Clicked;

        }

        private void ButtonAddizione_Clicked(object? sender, EventArgs e)
        {
            try
            {
                // se arrivo qua dentro utente ha fatto click sul botton
                //DisplayAlertAsync("titolo", "messaggio", "OK");
                // dobbiamo prelevare i dati dai due Entry
                // fare i calcoli etc...
                String PrimoNumeroString, SecondoNumeroString, Messaggio;
                Double PrimoNumero, SecondoNumero, Addizione;

                // prelevo i dati (String)
                PrimoNumeroString = this.EntryPrimoNumero.Text;
                SecondoNumeroString = this.EntrySecondoNumero.Text;

                // non posso fare i calcoli con le String, devo convertire
                // in Double
                PrimoNumero = Convert.ToDouble(PrimoNumeroString);
                SecondoNumero = Convert.ToDouble(SecondoNumeroString);

                Addizione = PrimoNumero + SecondoNumero;

                // fase di output
                this.EntryRisultato.Text = Convert.ToString(Addizione);
            }
            catch (Exception myException)
            {
                // ho beccato una eccezione (sacramento)
                DisplayAlertAsync("Problema", "Eccezione: " + myException.Message, "OK");
            }

        }
    }
}
